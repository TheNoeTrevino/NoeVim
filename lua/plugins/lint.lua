return {
  "mfussenegger/nvim-lint",
  opts = {
    -- Update events to include file change events
    events = { "BufWritePost", "BufReadPost", "InsertLeave", "BufEnter", "TextChanged", "TextChangedI" },

    linters_by_ft = {
      sql = { "sqruff", "squawk" },
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
          return ctx.filename:match("backend/migrations/.*%.sql$") ~= nil
        end,
      },
    },
  },

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
        -- Check if timer is valid before using it
        if timer and timer:is_active() then
          timer:stop()
        end
        -- Make sure timer is valid before starting
        if timer then
          timer:start(ms, 0, function()
            -- Check timer is valid
            if timer then
              timer:stop()
            end
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end
    end

    function M.lint()
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)

      names = vim.list_extend({}, names)

      if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
      end

      vim.list_extend(names, lint.linters_by_ft["*"] or {})

      local ctx = { filename = vim.api.nvim_buf_get_name(0) }
      ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
          print("Linter not found: " .. name, { title = "nvim-lint" })
        end
        -- Use safer condition check
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
      end, names)

      if #names > 0 then
        lint.try_lint(names)
      end
    end

    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = M.debounce(300, M.lint), -- Increased debounce to 300ms for better performance
    })
  end,
}
