return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = {
    inlay_hints = { enabled = false },
  },
  servers = {
    omnisharp = {
      enabled = false,
      mason = false,
      autostart = false,
    },
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
  -- config = function()
  --   if require("lspconfig").omnisharp then
  --     require("lspconfig").omnisharp = nil
  --   end
  -- end,
}
