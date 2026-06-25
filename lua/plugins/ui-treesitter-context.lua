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
    -- `separator` draws the thin border line under the context, colored by the
    -- TreesitterContextSeparator highlight (#101F28, set in the kanagawa spec).
    -- Note: with a separator set, the context only shows when there are >=2 lines
    -- above the cursor line.
    return { mode = "cursor", max_lines = 3, separator = "─" }
  end,
}
