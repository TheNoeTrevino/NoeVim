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

  { "nvchad/volt", lazy = true },
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
    "andymass/vim-matchup",
    event = "VeryLazy",
    config = function()
      vim.g.matchup_matchparen_enabled = 1
      vim.g.matchup_matchparen_hi_surround_always = 1
      vim.g.matchup_delim_nomids = 1
      vim.g.matchup_delim_noskips = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.api.nvim_set_hl(0, "MatchParen", { fg = "#FF9D3C" })
    end,
  },

  {
    "xiyaowong/virtcolumn.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      vim.opt.colorcolumn = "80,100,120"
      vim.api.nvim_set_hl(0, "VirtColumn", { fg = "#192020", bg = nil })
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
          height = 5,
          col = 2,
          focusable = false,
          border = "rounded",
          noautocmd = true,
        },
      })
    end,
  },
}
