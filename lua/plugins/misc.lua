return {
  -- Util
  { "debugloop/telescope-undo.nvim", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "mbbill/undotree", event = "VeryLazy" },
  { "ThePrimeagen/vim-be-good", event = "VeryLazy" },
  { "tummetott/unimpaired.nvim", event = "VeryLazy" },
  { "knubie/vim-kitty-navigator", event = "VeryLazy" },
  { "stevearc/oil.nvim", event = "VeryLazy", opts = {} },
  { "kiyoon/telescope-insert-path.nvim", event = "VeryLazy" },
  { "nvim-treesitter/nvim-treesitter-refactor", event = "VeryLazy" },
  { "opdavies/toggle-checkbox.nvim", event = "VeryLazy" },
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy" },
  { "gcmt/vessel.nvim", event = "VeryLazy" },

  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    config = function()
      require("marks").setup({
        mappings = {
          preview = "mp",
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
}
