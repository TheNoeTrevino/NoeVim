return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = {
    inlay_hints = { enabled = false },
  },
  servers = {
    omnisharp = false,
    angularls = {
      mason = false,
      autostart = false,
    },
    basedpyright = {
      mason = false,
      autostart = false,
    },
    ruff = {
      mason = false,
      autostart = false,
    },
    markdownlint = {
      mason = false,
      autostart = false,
    },
    eslint = {
      mason = false,
      autostart = false,
    },
  },
}
