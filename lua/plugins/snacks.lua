return {
  "folke/snacks.nvim",
  event = "VeryLazy",
  opts = {
    indent = { animate = { enabled = false } },
    statuscolumn = { enabled = false },
    dashboard = { enabled = false },
    scroll = {
      animate = {
        duration = { step = 15, total = 120 },
        easing = "linear",
      },
      -- what buffers to animate
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false
      end,
    },
  },
}
