-- Better `gc` comment handling using treesitter (context-aware commentstring).
-- Enabled/gated in disable.lua (non-win32).
return {
  "folke/ts-comments.nvim",
  event = "VeryLazy",
  opts = {},
}
