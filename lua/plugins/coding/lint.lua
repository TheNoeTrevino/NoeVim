-- nvim-lint: debounced lint runner (see the config function below). Personal
-- linters/linters_by_ft fold in on top of the base (fish), the personal ones winning.

-- `dynamic_args` and `dynamic_cwd` are our own convention, not nvim-lint's: neither
-- field exists on lint.Linter. `wrap_linter` (in the config function below) reads
-- them off a deep copy right before a linter runs and writes the result into the
-- real `args`/`cwd` fields nvim-lint understands.
---@alias MyLintArgList (string|fun():string)[]

---@class MyLintDynamicFields
---@field dynamic_args? fun(buf: number): MyLintArgList
---@field dynamic_cwd? fun(buf: number): string
---@field prepend_args? string[]
---@field condition? fun(ctx: {filename: string, dirname: string}): boolean

-- Entries here are partial overrides merged into an existing builtin
-- (sqlfluff), so lint.Linter's required `name`/`cmd`/`parser` don't apply --
-- this does NOT extend lint.Linter, every field is optional on purpose.
---@class MyLintLinterOverride: MyLintDynamicFields
---@field name? string
---@field cmd? string
---@field args? MyLintArgList
---@field cwd? string
---@field parser? lint.Parser|lint.parse

-- A real lint.Linter (as read out of nvim-lint's own registry at runtime) plus
-- our custom fields -- used only for the `---@cast`s below, where the value
-- genuinely is a complete Linter already, unlike the override table above.
---@class MyLintAugmentedLinter: lint.Linter, MyLintDynamicFields

---@type table<string, MyLintLinterOverride>
local linter_overrides = {
  -- The builtin passes no `--dialect`, so sqlfluff bails with "User Error: No
  -- dialect was specified" on stderr -- a stream nvim-lint never reads, making the
  -- linter a silent no-op. Build the argv from `util.sql`, the same resolver the
  -- sqlfluff FORMATTER uses in format.lua.
  --
  -- nvim-lint's native `args` can hold functions, but each returns exactly one
  -- string, so an argument can never be OMITTED -- and sqlfluff needs that: passing
  -- `--exclude-rules=` when a `--config` file is in play wipes the exclusions that
  -- file declares.
  sqlfluff = {
    ---@param buf number
    dynamic_args = function(buf)
      local args = { "lint", "--format=json" }
      vim.list_extend(args, require("util").sql.flags(buf))
      table.insert(args, "-")
      return args
    end,
  },
  -- squawk = {
  --   cmd = "squawk",
  --   stdin = false,
  --   args = {
  --     "--reporter",
  --     "Json",
  --     vim.api.nvim_buf_get_name(0),
  --   },
  --   stream = "stdout",
  --   ignore_exitcode = true,
  --
  --   parser = function(output, bufnr)
  --     local ok, decoded = pcall(vim.json.decode, output)
  --
  --     if not ok or type(decoded) ~= "table" then
  --       print("Something went wrong with the json decoding. squak lint config")
  --       return {}
  --     end
  --
  --     local diagnostics = {}
  --
  --     for _, item in ipairs(decoded) do
  --       table.insert(diagnostics, {
  --         bufnr = bufnr,
  --         lnum = (item.line or 1),
  --         col = (item.column or 1),
  --         end_lnum = (item.line or 1),
  --         end_col = item.column or 1,
  --         severity = vim.diagnostic.severity.WARN,
  --         source = "squawk",
  --         message = "Problem: "
  --           .. item.message
  --           .. (type(item.rule_name) == "string" and (" [" .. item.rule_name .. "]") or "")
  --           .. (type(item.help) == "string" and ("\n" .. "Solution: " .. item.help) or ""),
  --       })
  --     end
  --
  --     return diagnostics
  --   end,
  --
  --   condition = function(ctx)
  --     if not ctx.filename or vim.loop.fs_stat(ctx.filename) == nil then
  --       -- File doesn't exist, skip linting
  --       return false
  --     end
  --     -- if a file has the annotation @migration, the file will be treated
  --     -- as a migration file
  --     local is_migration = ctx.filename:match("backend/migrations/.*%.sql$") ~= nil
  --       or ctx.filename:match("migration")
  --
  --     if not is_migration then
  --       local content = vim.fn.readfile(ctx.filename) -- here
  --       for _, line in ipairs(content) do
  --         if line:match("%-%-@migration") then
  --           return true
  --         end
  --       end
  --       return false
  --     end
  --
  --     return true
  --   end,
  -- },
}

return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  opts = {
    -- Update events to include file change events
    events = { "BufWritePost", "BufReadPost", "InsertLeave", "BufEnter", "TextChanged", "TextChangedI" },

    linters_by_ft = {
      -- base
      fish = { "fish" },
      -- user
      -- mysql/plsql get sqlfluff from lang-sql.lua, which owns the sql filetype list.
      sql = { "sqlfluff" },
      markdown = { nil },
    },

    linters = linter_overrides,
  },
  -- Debounced lint runner: lints on the events below, skipping when the buffer can't be modified.
  config = function(_, opts)
    local M = {}

    local lint = require("lint")
    for name, linter in pairs(opts.linters) do
      -- `lint.linters[name]` can be a factory function as well as a table (per
      -- nvim-lint's own type), so it's read into a local first: lua_ls narrows a
      -- `type(x) == "table"` check reliably on a local, not on a repeated field
      -- access.
      local existing = lint.linters[name]
      if type(linter) == "table" and type(existing) == "table" then
        lint.linters[name] = vim.tbl_deep_extend("force", existing, linter)
        if type(linter.prepend_args) == "table" then
          lint.linters[name].args = lint.linters[name].args or {}
          vim.list_extend(lint.linters[name].args, linter.prepend_args)
        end
      else
        lint.linters[name] = linter
      end
    end
    lint.linters_by_ft = opts.linters_by_ft

    function M.debounce(ms, fn)
      -- new_timer() is typed nilable; assert it once so `timer:start`/`timer:stop`
      -- below don't need their own nil checks.
      local timer = assert(vim.uv.new_timer())
      return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
          timer:stop()
          vim.schedule_wrap(fn)(unpack(argv))
        end)
      end
    end

    function M.lint()
      -- Use nvim-lint's logic first:
      -- * checks if linters exist for the full filetype first
      -- * otherwise will split filetype by "." and add all those linters
      -- * this differs from conform.nvim which only uses the first filetype that has a formatter
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)

      -- Create a copy of the names table to avoid modifying the original.
      names = vim.list_extend({}, names)

      -- Add fallback linters.
      if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
      end

      -- Add global linters.
      vim.list_extend(names, lint.linters_by_ft["*"] or {})

      -- Filter out linters that don't exist or don't match the condition.
      local ctx = { filename = vim.api.nvim_buf_get_name(0) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
          require("util").warn("Linter not found: " .. name, { title = "nvim-lint" })
          return false
        end
        if type(linter) ~= "table" then
          return true
        end
        ---@cast linter MyLintAugmentedLinter
        return not (linter.condition and not linter.condition(ctx))
      end, names)

      -- Run linters.
      if #names > 0 then
        lint.try_lint(names, {
          -- Let a linter build its whole argv per run via `dynamic_args`, or its run
          -- directory via `dynamic_cwd` (see sqlfluff above).
          -- nvim-lint evaluates native `args` element-by-element, one string each,
          -- so the list length is fixed at config time, and its `cwd` must be a
          -- plain string set at plugin-setup time -- neither can react to which
          -- buffer is being linted on its own. `linter` is already a deepcopy here,
          -- so mutating it cannot leak into the next run.
          wrap_linter = function(linter)
            ---@cast linter MyLintAugmentedLinter
            if type(linter.dynamic_args) == "function" then
              linter.args = linter.dynamic_args(vim.api.nvim_get_current_buf())
            end
            if type(linter.dynamic_cwd) == "function" then
              linter.cwd = linter.dynamic_cwd(vim.api.nvim_get_current_buf())
            end
            return linter
          end,
        })
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = M.debounce(100, M.lint),
    })
  end,
}
