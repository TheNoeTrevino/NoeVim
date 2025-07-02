return {
  -- Util
  -- { "ThePrimeagen/vim-be-good", event = "VeryLazy" },
  { "knubie/vim-kitty-navigator", event = "VeryLazy" },
  { "backdround/improved-search.nvim", event = "VeryLazy" },
  -- {
  --   "meznaric/key-analyzer.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("key-analyzer").setup({
  --       -- Name of the command to use for the plugin
  --       command_name = "KeyAnalyzer", -- or nil to disable the command
  --
  --       -- Customize the highlight groups
  --       highlights = {
  --         bracket_used = "KeyAnalyzerBracketUsed",
  --         letter_used = "KeyAnalyzerLetterUsed",
  --         bracket_unused = "KeyAnalyzerBracketUnused",
  --         letter_unused = "KeyAnalyzerLetterUnused",
  --         promo_highlight = "KeyAnalyzerPromo",
  --
  --         -- Set to false if you want to define highlights manually
  --         define_default_highlights = true,
  --       },
  --     })
  --   end,
  -- },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "kiennt63/harpoon-files.nvim",
    event = "UIEnter",
    dependencies = {
      { "ThePrimeagen/harpoon" },
    },
    opts = {
      max_length = 15,
      icon = "",
      show_icon = true,
      show_index = true,
      show_filename = true,
      separator_left = "",
      separator_right = "",
    },
  },
  -- {
  --   "roobert/surround-ui.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "kylechui/nvim-surround",
  --     "folke/which-key.nvim",
  --   },
  --   config = function()
  --     require("surround-ui").setup({
  --       root_key = "S",
  --     })
  --   end,
  -- },
  {
    "aliqyan-21/wit.nvim",
    event = "VeryLazy",
    config = function()
      require("wit").setup({})
      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })
    end,
  },
  {
    "vyfor/cord.nvim",
    event = "VeryLazy",
    build = ":Cord update",
    -- opts = {}
  },
  {
    "pocco81/high-str.nvim",
    event = "VeryLazy",
    config = {
      verbosity = 0,
      saving_path = "/tmp/highstr/",
      highlight_colors = {
        color_0 = { "#0c0d0e", "smart" },
        color_1 = { "#e5c07b", "smart" },
        color_2 = { "#7FFFD4", "smart" },
        color_3 = { "#8A2BE2", "smart" },
        color_4 = { "#FF4500", "smart" },
        color_5 = { "#008000", "smart" },
        color_6 = { "#0000FF", "smart" },
        color_7 = { "#FFC0CB", "smart" },
        color_8 = { "#FFF9E3", "smart" },
        color_9 = { "#7d5c34", "smart" },
      },
    },
  },
}
