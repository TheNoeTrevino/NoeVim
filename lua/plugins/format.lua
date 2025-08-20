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
      },
    },
    formatters_by_ft = {
      ["java"] = { "google-java-format" },
      ["xml"] = { "xmlformat" },
      ["htmlangular"] = { "prettier" },
      ["cs"] = { "csharpier" },
      ["typescript"] = { "biome" },
      ["sql"] = { "sqruff" },
      ["markdown"] = {},
      ["markdown.mdx"] = {},
    },
  },
  -- dotnet tool install -g csharpier
}
