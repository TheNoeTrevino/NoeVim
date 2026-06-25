-- Vendored from the LazyVim distro (lazyvim/plugins/extras/ui/treesitter-context.lua) with `Util` aliased to our
-- local util. none-ls specs are optional+absent (lazy skips them); `recommended` is unused
-- (now a flat spec in lua/plugins/).
local Util = require("util")
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
