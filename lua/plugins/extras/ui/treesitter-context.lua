-- Vendored from LazyVim (lazyvim/plugins/extras/ui/treesitter-context.lua) with `LazyVim` aliased to our
-- local util. none-ls specs are optional+absent (lazy skips them); `recommended` is unused
-- (extras are imported explicitly, no :LazyExtras UI).
local LazyVim = require("util")
-- Show context of the current function
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "LazyFile",
  opts = function()
    local tsc = require("treesitter-context")
    Snacks.toggle({
      name = "Treesitter Context",
      get = tsc.enabled,
      set = function(state)
        if state then
          tsc.enable()
        else
          tsc.disable()
        end
      end,
    }):map("<leader>ut")
    return { mode = "cursor", max_lines = 3 }
  end,
}
