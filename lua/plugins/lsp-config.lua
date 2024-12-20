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
      formatters_by_ft = {
        ["markdown"] = {},
        ["markdown.mdx"] = {},
        ["java"] = { "google-java-format" }, -- Add this line for Java formatter
      },
    },
  },
}
