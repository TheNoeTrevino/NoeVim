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
