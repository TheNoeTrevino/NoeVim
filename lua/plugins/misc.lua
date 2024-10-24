return {
  -- Util
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "ThePrimeagen/vim-be-good", event = "VeryLazy" },
  { "tummetott/unimpaired.nvim", event = "VeryLazy" },
  { "knubie/vim-kitty-navigator", event = "VeryLazy" },
  { "stevearc/oil.nvim", event = "VeryLazy", opts = {} },
  { "backdround/improved-search.nvim", event = "VeryLazy" },
  { "nvchad/volt", lazy = true },
  {
    "nvchad/minty",
    cmd = { "Shades", "Huefy" },
  },
  {
    "nvchad/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
      timeout = 1,
      maxkeys = 5,
      position = "top-center",
    },
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "roobert/surround-ui.nvim",
    event = "VeryLazy",
    dependencies = {
      "kylechui/nvim-surround",
      "folke/which-key.nvim",
    },
    config = function()
      require("surround-ui").setup({
        root_key = "S",
      })
    end,
  },
  {
    "aliqyan-21/wit.nvim",
    event = "VeryLazy",
    config = function()
      require("wit").setup({})
    end,
  },
}
