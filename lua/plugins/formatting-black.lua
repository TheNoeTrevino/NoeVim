-- Vendored from the LazyVim distro (lazyvim/plugins/extras/formatting/black.lua) with `Util` aliased to our
-- local util. none-ls specs are optional+absent (lazy skips them); `recommended` is unused
-- (now a flat spec in lua/plugins/).
local Util = require("util")
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
