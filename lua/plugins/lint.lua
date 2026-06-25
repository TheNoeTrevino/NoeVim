-- Self-sufficient nvim-lint spec. The config function (debounced lint runner) is
-- vendored from LazyVim's lazyvim/plugins/linting.lua; LazyVim.warn -> util.warn.
-- User's linters/linters_by_ft fold in on top of the base (fish), user winning.
return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  opts = {
    -- Update events to include file change events
    events = { "BufWritePost", "BufReadPost", "InsertLeave", "BufEnter", "TextChanged", "TextChangedI" },

    linters_by_ft = {
      -- base (from LazyVim linting.lua)
      fish = { "fish" },
      -- user
      sql = { "sqruff", "squawk" },
      go = { nil },
      markdown = { nil },
    },

    linters = {
      sqruff = {},
      squawk = {
        cmd = "squawk",
        stdin = false,
        args = {
          "--reporter",
          "Json",
          vim.api.nvim_buf_get_name(0),
        },
        stream = "stdout",
        ignore_exitcode = true,

        parser = function(output, bufnr)
          local ok, decoded = pcall(vim.json.decode, output)

          if not ok or type(decoded) ~= "table" then
            print("Something went wrong with the json decoding. squak lint config")
            return {}
          end

          local diagnostics = {}

          for _, item in ipairs(decoded) do
            table.insert(diagnostics, {
              bufnr = bufnr,
              lnum = (item.line or 1),
              col = (item.column or 1),
              end_lnum = (item.line or 1),
              end_col = item.column or 1,
              severity = vim.diagnostic.severity.WARN,
              source = "squawk",
              message = "Problem: "
                .. item.message
                .. (type(item.rule_name) == "string" and (" [" .. item.rule_name .. "]") or "")
                .. (type(item.help) == "string" and ("\n" .. "Solution: " .. item.help) or ""),
            })
          end

          return diagnostics
        end,

        condition = function(ctx)
          if not ctx.filename or vim.loop.fs_stat(ctx.filename) == nil then
            -- File doesn't exist, skip linting
            return false
          end
          -- if a file has the annotation @migration, the file will be treated
          -- as a migration file
          local is_migration = ctx.filename:match("backend/migrations/.*%.sql$") ~= nil
            or ctx.filename:match("migration")

          if not is_migration then
            local content = vim.fn.readfile(ctx.filename) -- here
            for _, line in ipairs(content) do
              if line:match("%-%-@migration") then
                return true
              end
            end
            return false
          end

          return true
        end,
      },
    },
  },
  -- Vendored from LazyVim lazyvim/plugins/linting.lua (config), LazyVim.warn -> util.warn.
  config = function(_, opts)
    local M = {}

    local lint = require("lint")
    for name, linter in pairs(opts.linters) do
      if type(linter) == "table" and type(lint.linters[name]) == "table" then
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
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
      local timer = vim.uv.new_timer()
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
        end
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
      end, names)

      -- Run linters.
      if #names > 0 then
        lint.try_lint(names)
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = M.debounce(100, M.lint),
    })
  end,
}
