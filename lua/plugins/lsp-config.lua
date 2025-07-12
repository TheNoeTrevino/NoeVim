return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = {
    inlay_hints = { enabled = false },
  },
  servers = {
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
  },
}
