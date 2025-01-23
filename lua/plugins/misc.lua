return {
  -- Util
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "ThePrimeagen/vim-be-good", event = "VeryLazy" },
  { "tummetott/unimpaired.nvim", event = "VeryLazy" },
  { "knubie/vim-kitty-navigator", event = "VeryLazy" },
  { "backdround/improved-search.nvim", event = "VeryLazy" },
  {
    "meznaric/key-analyzer.nvim",
    event = "VeryLazy",
    config = function()
      require("key-analyzer").setup({
        -- Name of the command to use for the plugin
        command_name = "KeyAnalyzer", -- or nil to disable the command

        -- Customize the highlight groups
        highlights = {
          bracket_used = "KeyAnalyzerBracketUsed",
          letter_used = "KeyAnalyzerLetterUsed",
          bracket_unused = "KeyAnalyzerBracketUnused",
          letter_unused = "KeyAnalyzerLetterUnused",
          promo_highlight = "KeyAnalyzerPromo",

          -- Set to false if you want to define highlights manually
          define_default_highlights = true,
        },
      })
    end,
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
