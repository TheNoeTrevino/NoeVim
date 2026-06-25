-- Vendored from LazyVim (lazyvim/plugins/extras/formatting/black.lua) with `LazyVim` aliased to our
-- local util. none-ls specs are optional+absent (lazy skips them); `recommended` is unused
-- (extras are imported explicitly, no :LazyExtras UI).
local LazyVim = require("util")
return {
  {
    "mason-org/mason.nvim",
    -- table form composes with mason's opts_extend = { "ensure_installed" }.
    opts = { ensure_installed = { "black" } },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.black)
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { "black" },
      },
    },
  },
}
