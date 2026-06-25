-- Vendored from LazyVim (lazyvim/plugins/extras/lang/toml.lua) with `LazyVim` aliased to our
-- local util. none-ls specs are optional+absent (lazy skips them); `recommended` is unused
-- (extras are imported explicitly, no :LazyExtras UI).
local LazyVim = require("util")
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = {},
    },
  },
}
