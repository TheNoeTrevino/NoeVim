return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = "LazyFile",
  opts = {
    keywords = {
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      BETTER = {
        icon = " ", -- icon used for the sign, and in search results
        color = "improve", -- can be a hex color, or a named color (see below)
        alt = { "IMP", "BAD", "Improve", "IMPROVE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = " ", color = "info", alt = { "Todo" } },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX", "Warn" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", "BEST" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO", "Info", "Note" } },
      TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED", "Test" } },
    },
    -- list of named colors where we try to extract the guifg from the
    -- list of highlight groups or use the hex color if hl not found as a fallback
    -- PERF:
    -- HACK:
    -- NOTE:
    -- Todo:
    -- WARNING:
    -- FIX:
    -- TEST:
    -- BETTER:
    colors = {
      error = { "#DA4B4A" },
      warning = { "#FBBF24" },
      info = { "#07BAD8" },
      hint = { "#0FBA81" },
      default = { "#BB9BF7" },
      test = { "#FF00FF" },
      improve = { "#4d43fa" },
    },
  },
}
