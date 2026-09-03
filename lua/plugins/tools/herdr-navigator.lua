return {
  "willfish/herdr-navigator.nvim",
  event = "VeryLazy",
  opts = {
    mappings = {
      left = "<C-h>",
      down = "<C-j>",
      up = "<C-k>",
      right = "<C-l>",
    },
  },
  -- setup() is called explicitly. Relying on lazy's opts -> main.setup(opts)
  -- shortcut silently produced the plugin's default <M-hjkl> maps instead.
  config = function(_, opts)
    require("herdr-navigator").setup(opts)
  end,
}
