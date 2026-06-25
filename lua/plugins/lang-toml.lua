-- Vendored from the LazyVim distro (lazyvim/plugins/extras/lang/toml.lua) with `Util` aliased to our
-- local util. none-ls specs are optional+absent (lazy skips them); `recommended` is unused
-- (now a flat spec in lua/plugins/).
local Util = require("util")
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = {},
    },
  },
}
