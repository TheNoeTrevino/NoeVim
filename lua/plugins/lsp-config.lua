return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      inlay_hints = { enabled = false },
      -- inlay_hints = {
      --   enabled = function(server_name)
      --     return server_name ~= "gopls"
      --   end,
      -- },
      servers = {
        basedpyright = {
          mason = false,
          autostart = false,
        },
        ruff = {
          mason = false,
          autostart = false,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        sqruff = {},
      },
      formatters_by_ft = {
        ["java"] = { "prettier", "google-java-format" },
        ["xml"] = { "xmlformat" },
        ["htmlangular"] = { "prettier" },
        ["cs"] = { "csharpier" },
        ["typescript"] = { "biome" },
        ["sql"] = { "sqruff" },
        ["markdown"] = {},
        ["markdown.mdx"] = {},
      },
    },
  },
}
