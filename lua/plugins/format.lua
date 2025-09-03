return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters = {
      sqruff = {},
      prettier = {
        require_cwd = true,
        condition = function(_, ctx)
          local supported =
            { "javascript", "typescript", "css", "html", "htmlangular", "json", "java", "typescriptreact" }
          local ft = vim.bo[ctx.buf].filetype
          return vim.tbl_contains(supported, ft)
        end,
        cwd = function(self, ctx)
          local found = vim.fs.find({ "frontend" }, { upward = true, path = ctx.dirname })[1]
          if found then
            return found
          end
        end,
        -- Dont forget to npm install prettier and the java plugin
        append_args = { "--config", ".prettierrc.json" },
      },
      ["markdown-toc"] = {
        condition = function(_, ctx)
          for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
            if line:find("<!%-%- toc %-%->") then
              return true
            end
          end
        end,
      },
    },
    formatters_by_ft = {
      -- ["java"] = { "google-java-format" },
      ["java"] = { "prettier" },
      ["xml"] = { "xmlformat" },
      ["htmlangular"] = { "prettier" },
      ["cs"] = { "csharpier" },
      ["typescript"] = { "biome" },
      ["sql"] = { "sqruff" },
      ["markdown"] = { "markdown-toc" },
      ["markdown.mdx"] = { "markdown-toc" },
    },
  },
  -- dotnet tool install -g csharpier
}
