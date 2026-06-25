-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  "folke/snacks.nvim",
  -- Self-sufficient now that LazyVim core no longer provides the base Snacks spec.
  -- (Util loaded snacks at startup with priority 1000 and restored vim.notify for noice.)
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    local notify = vim.notify
    require("snacks").setup(opts)
    -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
    if require("util").has("noice.nvim") then
      vim.notify = notify
    end
  end,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    words = { enabled = true },
    toggle = { map = require("util").safe_keymap_set },
    terminal = {
      win = {
        keys = {
          nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
          nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
          nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
          nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
          hide_underscore = { "<c-_>", "hide", desc = "which_key_ignore", mode = "t" },
        },
      },
    },
    indent = { enabled = false },
    image = { enabled = true },
    statuscolumn = { enabled = false }, -- we set this in options.lua
    scope = { enabled = false },
    lazygit = {
      win = {
        style = "lazygit",
        width = 0,
        height = 0,
      },
    },
    scroll = {
      enabled = false,
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
  config = function(_, opts)
    local notify = vim.notify
    require("snacks").setup(opts)
    -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
    -- this is needed to have early notifications show up in noice history
    if require("util").has("noice.nvim") then
      vim.notify = notify
    end
  end,
}
