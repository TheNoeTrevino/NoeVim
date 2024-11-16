return {
  -- Util
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "ThePrimeagen/vim-be-good", event = "VeryLazy" },
  { "tummetott/unimpaired.nvim", event = "VeryLazy" },
  { "knubie/vim-kitty-navigator", event = "VeryLazy" },
  { "stevearc/oil.nvim", event = "VeryLazy", opts = {} },
  { "backdround/improved-search.nvim", event = "VeryLazy" },
  { "Pocco81/HighStr.nvim", event = "VeryLazy" },
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
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "cbochs/portal.nvim",
    event = "VeryLazy",
    config = function()
      require("portal").setup({
        ---@type string[]
        labels = { "j", "k", "l", ";" },
        window_options = {
          relative = "cursor",
          width = 80,
          height = 6,
          col = 2,
          focusable = false,
          border = "rounded",
          noautocmd = true,
        },
      })
    end,
  },
  {
    "andrewferrier/debugprint.nvim",
    opts = {
      keymaps = {
        normal = {
          plain_below = "<leader>xPp",
          plain_above = "<leader>xPP",
          variable_below = "<leader> xPv",
          variable_above = "<leader> xPV",
          variable_below_alwaysprompt = nil,
          variable_above_alwaysprompt = nil,
          textobj_below = "<leader>xPo",
          textobj_above = "<leader>xPO",
          toggle_comment_debug_prints = nil,
          delete_debug_prints = nil,
        },
      },
      commands = {
        toggle_comment_debug_prints = "ToggleCommentDebugPrints",
        delete_debug_prints = "DeleteDebugPrints",
      },
    },
  },
}
