return {
  "stevearc/conform.nvim",
  optional = true,
  event = "BufWritePre",
  opts = {
    formatters = {
      sqruff = {},
      csharpier = {
        condition = function(_, _)
          local cwd = vim.fn.getcwd():gsub("\\", "/")
          return not vim.endswith(cwd, "/projects/cast")
        end,
      },
      prettier = {
        require_cwd = true,
        condition = function(_, ctx)
          local cwd = vim.fn.getcwd()
          if string.find(cwd, "careview", 1, true) == nil then
            return false
          end
          local supported =
            { "javascript", "typescript", "css", "html", "htmlangular", "json", "java", "typescriptreact" }
          local ft = vim.bo[ctx.buf].filetype
          return vim.tbl_contains(supported, ft)
        end,
        -- cwd = require("conform.util").root_file({
        --   ".prettierrc",
        --   ".prettierrc.json",
        --   ".prettierrc.js",
        --   "prettier.config.js",
        --   "package.json",
        -- }),
        -- Dont forget to npm install prettier and the java plugin
        cwd = function(self, ctx)
          local found = vim.fs.find({ "frontend" }, { upward = true, path = ctx.dirname })[1]
          if found then
            return found
          end
        end,
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
      ["tsx"] = { "prettier" },
      ["htmlangular"] = { "prettier" },
      ["typescript"] = { "prettier" },
      ["xml"] = { "xmlformat" },
      ["cs"] = { "csharpier" },
      ["sql"] = { "sqruff" },
      ["markdown"] = { "markdown-toc" },
      ["markdown.mdx"] = { "markdown-toc" },
    },
  },
  -- dotnet tool install -g csharpier
}
