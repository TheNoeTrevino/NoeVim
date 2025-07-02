return {
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
}
