return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    indent = { enabled = false },
    image = { enabled = true },
    statuscolumn = { enabled = false },
    dashboard = { enabled = true },
    scope = { enabled = false },
    lazygit = {
      win = {
        style = "lazygit",
        width = 0,
        height = 0,
      },
    },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 80 },
        easing = "linear",
      },
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false
      end,
    },
    scratch = {
      ft = function()
        return "markdown"
      end,
    },
    dim = {
      animate = {
        enabled = false,
      },
      filter = function(buf)
        return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
      end,
    },
  },
}
