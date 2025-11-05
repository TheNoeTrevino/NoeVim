return {
  "mfussenegger/nvim-lint",
  opts = {
    -- Update events to include file change events
    events = { "BufWritePost", "BufReadPost", "InsertLeave", "BufEnter", "TextChanged", "TextChangedI" },

    linters_by_ft = {
      sql = { "sqruff", "squawk" },
      go = { nil },
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
}
