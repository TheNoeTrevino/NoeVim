-- Dialect and config resolution shared by the sqlfluff FORMATTER (plugins/format.lua)
-- and the sqlfluff LINTER (plugins/lint.lua). They must agree: if `lint` and `format`
-- disagree on the dialect or the rule set you get diagnostics that the formatter then
-- rewrites into different diagnostics, forever. Both build their argv from `M.flags()`.
--
-- sqlfluff has no dialect autodetection and refuses to run without one:
--   "User Error: No dialect was specified."
-- That lands on *stderr*, and nvim-lint only reads stdout, so a dialect-less linter fails
-- silently (zero diagnostics, no message). `M.dialect()` therefore always returns one.

local M = {}

-- dadbod url scheme -> sqlfluff dialect. Only schemes sqlfluff actually knows are listed
-- (`sqlfluff dialects`); anything else falls through.
M.scheme_dialects = {
  athena = "athena",
  bigquery = "bigquery",
  clickhouse = "clickhouse",
  databricks = "databricks",
  db2 = "db2",
  duckdb = "duckdb",
  exasol = "exasol",
  hive = "hive",
  impala = "impala",
  mariadb = "mariadb",
  mysql = "mysql",
  oracle = "oracle",
  postgres = "postgres",
  postgresql = "postgres",
  presto = "trino",
  redshift = "redshift",
  snowflake = "snowflake",
  spark = "sparksql",
  sparksql = "sparksql",
  sqlite = "sqlite",
  sqlserver = "tsql",
  teradata = "teradata",
  trino = "trino",
  vertica = "vertica",
}

-- Filetypes that name their own dialect. Plain `sql` says nothing, so it falls through.
M.ft_dialects = { mysql = "mysql", plsql = "oracle" }

-- Case-insensitive SUBSTRING of the buffer's full path -> dialect. These projects are SQL
-- Server work whose .sql files carry no other usable marker: opened straight off disk
-- there is no dadbod connection, and the `sql` filetype says nothing. Without this they
-- resolve to ansi, which reports every T-SQL construct (GO, USE, CREATE OR ALTER,
-- [brackets]) as an unparsable section.
M.path_dialects = {
  nmcris = "tsql",
  careview = "tsql",
}

M.default = "ansi"

-- Per-dialect settings files, `<dialect>.sqlfluff`, holding the options that have no CLI
-- equivalent (max_line_length, per-rule policies). Named `<dialect>.sqlfluff` rather than
-- `.sqlfluff` on purpose, so sqlfluff's own upward discovery can never pick them up by
-- accident.
M.settings_dir = vim.fn.stdpath("config") .. "/sqlfluff"

-- Rule exclusions for dialects that have NO settings file, keyed by dialect; `["*"]`
-- applies everywhere and is concatenated with the dialect's own list. Dialects with a
-- settings file put their exclusions in that file instead -- see `M.exclude_rules_args()`
-- for why the two can't be combined.
M.exclude_rules = {
  ["*"] = { "AL01", "AM05" },
}

---@param buf? number
---@return number
local function normalize(buf)
  return (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
end

-- The config files sqlfluff reads, with the ini/toml section that must hold `dialect`.
-- `section = nil` means scan the whole file (a `.sqlfluff` is sqlfluff-only, and no
-- section other than `[sqlfluff]` defines `dialect`).
local config_files = {
  { name = ".sqlfluff", section = nil },
  { name = "pyproject.toml", section = "tool.sqlfluff" },
  { name = "setup.cfg", section = "sqlfluff" },
  { name = "tox.ini", section = "sqlfluff" },
}

---@param path string
---@param section string? nil = scan the whole file
---@return string?
local function read_dialect(path, section)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end
  local in_section = section == nil
  for _, line in ipairs(lines) do
    local header = line:match("^%s*%[%s*([^%]]-)%s*%]")
    if header and section then
      in_section = header == section
    elseif in_section then
      local dialect = line:match("^%s*dialect%s*=%s*[\"']?([%w_]+)")
      if dialect then
        return dialect
      end
    end
  end
end

-- Walking four config file names on every lint would mean disk reads on nearly every
-- keystroke (nvim-lint fires on TextChangedI), so the walk is cached per directory.
-- Adding or removing a project config mid-session needs `Util.sql.clear_cache()`.
local project_cache = {} ---@type table<string, {path:string, section:string?}|false>

function M.clear_cache()
  project_cache = {}
end

-- The nearest sqlfluff config the PROJECT ships, if any. Its mere existence matters:
-- a repo that configures sqlfluff outranks anything we would pass in.
---@param buf? number
---@return {path:string, section:string?}?
function M.project_config(buf)
  buf = normalize(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local dir = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()
  local cached = project_cache[dir]
  if cached ~= nil then
    return cached or nil
  end

  local found = nil
  for _, cfg in ipairs(config_files) do
    local path = vim.fs.find({ cfg.name }, { upward = true, path = dir, type = "file", limit = 1 })[1]
    if path then
      found = { path = path, section = cfg.section }
      break
    end
  end

  project_cache[dir] = found or false
  return found
end

-- The dialect declared by the project's own config, if it declares one.
---@param buf? number
---@return string?
function M.project_dialect(buf)
  local cfg = M.project_config(buf)
  return cfg and read_dialect(cfg.path, cfg.section) or nil
end

-- Resolve the dialect for a buffer, most specific evidence first:
--   1. an explicit `b:sqlfluff_dialect` / `g:sqlfluff_dialect` override
--   2. the live dadbod connection url (dadbod-ui query buffers, `:DB`)
--   3. a filetype that names a dialect (mysql, plsql)
--   4. the dialect the project's own sqlfluff config declares
--   5. a path substring from `M.path_dialects` (nmcris, careview)
--   6. `M.default` ("ansi")
-- Project config outranks the path substring deliberately: a repo that spells out its
-- dialect is authoritative, a substring match is a heuristic.
---@param buf? number
---@return string
function M.dialect(buf)
  buf = normalize(buf)

  local override = vim.b[buf].sqlfluff_dialect or vim.g.sqlfluff_dialect
  if type(override) == "string" and override ~= "" then
    return override
  end

  local db = vim.b[buf].db
  if type(db) == "string" then
    -- `postgresql+psycopg2://...` and friends carry a driver suffix; drop it.
    local scheme = db:match("^([%w_+%-]+):")
    if scheme then
      scheme = scheme:lower():gsub("%+.*", "")
      if M.scheme_dialects[scheme] then
        return M.scheme_dialects[scheme]
      end
    end
  end

  local ft = vim.bo[buf].filetype
  if M.ft_dialects[ft] then
    return M.ft_dialects[ft]
  end

  local declared = M.project_dialect(buf)
  if declared then
    return declared
  end

  local path = vim.api.nvim_buf_get_name(buf):lower()
  for substring, dialect in pairs(M.path_dialects) do
    if path:find(substring, 1, true) then
      return dialect
    end
  end

  return M.default
end

-- The settings file for a dialect, if we ship one.
---@param dialect string
---@return string?
function M.settings_file(dialect)
  local path = M.settings_dir .. "/" .. dialect .. ".sqlfluff"
  return vim.uv.fs_stat(path) and path or nil
end

-- `--config` OVERRIDES a project `.sqlfluff` rather than merging under it (verified
-- against sqlfluff 4.2.2), so it is only passed when the buffer has no project config of
-- its own. A repo that ships sqlfluff settings always wins.
---@param buf? number
---@return string[]
function M.config_args(buf)
  buf = normalize(buf)
  if M.project_config(buf) then
    return {}
  end
  local path = M.settings_file(M.dialect(buf))
  return path and { "--config", path } or {}
end

-- The rules to suppress. `b:sqlfluff_exclude_rules` / `g:sqlfluff_exclude_rules` (a list,
-- or a comma-separated string) REPLACES the table above rather than adding to it.
---@param buf? number
---@return string[]
function M.excluded_rules(buf)
  buf = normalize(buf)

  local override = vim.b[buf].sqlfluff_exclude_rules or vim.g.sqlfluff_exclude_rules
  if type(override) == "string" then
    return vim.split(override, "%s*,%s*", { trimempty = true })
  elseif type(override) == "table" then
    return override
  end

  local rules = vim.list_extend({}, M.exclude_rules["*"] or {})
  return vim.list_extend(rules, M.exclude_rules[M.dialect(buf)] or {})
end

-- `--exclude-rules=`, and ONLY when no `--config` is in play. `--exclude-rules` REPLACES
-- a config file's own `exclude_rules` instead of adding to it -- and it does so even when
-- passed empty, which silently re-enables everything the file turned off (verified
-- against sqlfluff 4.2.2). So a settings file is the sole source of truth for its
-- dialect's rules, and this is the fallback for dialects without one.
---@param buf? number
---@return string[]
function M.exclude_rules_args(buf)
  buf = normalize(buf)
  if #M.config_args(buf) > 0 then
    return {}
  end
  local rules = M.excluded_rules(buf)
  return #rules > 0 and { "--exclude-rules=" .. table.concat(rules, ",") } or {}
end

-- The dialect/config/rule flags every sqlfluff invocation needs. Variable length -- which
-- is why the linter builds its argv through nvim-lint's `wrap_linter` hook (see lint.lua)
-- rather than nvim-lint's own per-element arg functions, which cannot omit an argument.
---@param buf? number
---@return string[]
function M.flags(buf)
  buf = normalize(buf)
  local args = { "--dialect=" .. M.dialect(buf) }
  vim.list_extend(args, M.config_args(buf))
  vim.list_extend(args, M.exclude_rules_args(buf))
  return args
end

return M
