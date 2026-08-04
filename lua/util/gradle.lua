-- Overseer templates for the ICRIS gradle backend.
--
-- These only show up in projects that actually have a `gradlew` (searched upward
-- from the current dir, then two levels down so the repo root works even though
-- the wrapper lives in `backend/`).
--
-- Every command is run as `bash -c 'source ~/icris.sh && <env> ./gradlew ...'` so
-- the env functions from icris.sh (dev/local_dev/qa/qa2/prod) provide the
-- database + ArcGIS credentials. If icris.sh is missing we fall back to a bare
-- `./gradlew`, which keeps the templates usable in any other gradle project.
local M = {}

local ENV_FILE = vim.fs.normalize("~/icris.sh")
local ENVS = { "dev", "local_dev", "qa", "qa2", "prod" }
local DEFAULT_ENV = "dev"

---@type table<string, string|false>
local root_cache = {}

-- Directory containing `gradlew`, or nil.
---@param dir string
---@return string?
function M.find_root(dir)
  if root_cache[dir] ~= nil then
    return root_cache[dir] or nil
  end
  local root ---@type string?
  local upward = vim.fs.find("gradlew", { path = dir, upward = true, type = "file" })[1]
  if upward then
    root = vim.fs.dirname(upward)
  else
    for name, type in vim.fs.dir(dir, { depth = 2 }) do
      if type == "file" and vim.fs.basename(name) == "gradlew" then
        root = vim.fs.normalize(dir .. "/" .. vim.fs.dirname(name))
        break
      end
    end
  end
  root_cache[dir] = root or false
  return root
end

---@param env string
---@param args string
---@return string[]
local function shell_cmd(env, args)
  local gradlew = "./gradlew " .. args
  if vim.uv.fs_stat(ENV_FILE) then
    return { "bash", "-c", ("source %s && %s %s"):format(vim.fn.shellescape(ENV_FILE), env, gradlew) }
  end
  return { "bash", "-c", gradlew }
end

-- Task class name for the current buffer, e.g. `FooTests` -> `*.FooTests`.
---@return string?
local function current_test_filter()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return nil
  end
  local class = vim.fn.fnamemodify(name, ":t:r")
  return class ~= "" and ("*." .. class) or nil
end

-- The fixed task list: `{ label, gradle args, overseer tags }`.
local TASKS = {
  { "build", "build", { "BUILD" } },
  { "build (no tests)", "build -x test", { "BUILD" } },
  { "assemble", "assemble", { "BUILD" } },
  { "clean", "clean", { "CLEAN" } },
  { "clean build", "clean build", { "BUILD", "CLEAN" } },
  { "compile", "compileJava compileTestJava", { "BUILD" } },
  { "test", "test", { "TEST" } },
  { "test (rerun)", "test --rerun-tasks", { "TEST" } },
  { "test (info)", "test --info", { "TEST" } },
  { "simulationTest", "simulationTest", { "TEST" } },
  { "e2eTest", "e2eTest", { "TEST" } },
  { "check", "check", { "TEST" } },
  { "checkstyle", "checkstyleMain checkstyleTest", { "TEST" } },
  { "bootRun", "bootRun", { "RUN" } },
  { "generateDDL", "generateDDL", { "RUN" } },
  { "validateSql", "validateSql", { "RUN" } },
  { "buildFrontend", "buildFrontend", { "BUILD" } },
  { "cleanInstall", "cleanInstall", { "BUILD" } },
  { "frontend (copy to static)", "frontend", { "BUILD" } },
  { "tasks", "tasks --all", {} },
}

-- Templates for one gradle root. Cached so repeated searches in the same
-- project don't rebuild the list.
---@type table<string, table[]>
local template_cache = {}

---@param root string directory containing gradlew
local function build_templates(root)
  if template_cache[root] then
    return template_cache[root]
  end

  local TAG = require("overseer").TAG

  ---@param tags string[]
  local function resolve_tags(tags)
    return vim.tbl_map(function(t)
      return TAG[t]
    end, tags)
  end

  local templates = {}

  for i, spec in ipairs(TASKS) do
    local label, args, tags = spec[1], spec[2], spec[3]
    table.insert(templates, {
      name = "gradle " .. label,
      desc = "source icris.sh && " .. DEFAULT_ENV .. " ./gradlew " .. args,
      tags = resolve_tags(tags),
      priority = 50 + i,
      builder = function()
        return {
          cmd = shell_cmd(DEFAULT_ENV, args),
          cwd = root,
          components = { "default" },
        }
      end,
    })
  end

  -- Current file's test class.
  table.insert(templates, {
    name = "gradle test (current file)",
    desc = "./gradlew test --tests '*.<CurrentClass>'",
    tags = { TAG.TEST },
    priority = 45,
    condition = { filetype = { "java", "kotlin" } },
    builder = function()
      local filter = current_test_filter() or "*"
      return {
        cmd = shell_cmd(DEFAULT_ENV, ("test --tests '%s'"):format(filter)),
        cwd = root,
        components = { "default" },
      }
    end,
  })

  -- Free-form, with the env function selectable.
  table.insert(templates, {
    name = "gradle (custom)",
    desc = "Pick env function + gradle args",
    tags = {},
    priority = 40,
    params = {
      env = {
        type = "enum",
        choices = ENVS,
        default = DEFAULT_ENV,
        desc = "env function from icris.sh",
      },
      args = {
        type = "string",
        default = "test",
        desc = "gradle arguments",
      },
    },
    builder = function(params)
      return {
        cmd = shell_cmd(params.env, params.args),
        cwd = root,
        components = { "default" },
      }
    end,
  })

  template_cache[root] = templates
  return templates
end

function M.register_overseer_templates()
  -- The generator (not `condition`) does the gradlew gating: this overseer
  -- version's SearchCondition only supports `filetype`/`dir`, no callback.
  require("overseer").register_template({
    name = "icris gradle",
    cache_key = function(search)
      return M.find_root(search.dir)
    end,
    generator = function(search, cb)
      local root = M.find_root(search.dir)
      if not root then
        return cb({})
      end
      cb(build_templates(root))
    end,
  })
end

return M
