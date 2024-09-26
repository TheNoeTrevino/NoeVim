return {
  -- Util
  { "debugloop/telescope-undo.nvim", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "mbbill/undotree", event = "VeryLazy" },
  { "ThePrimeagen/vim-be-good", event = "VeryLazy" },
  { "nvim-neorg/neorg-telescope", event = "VeryLazy" },
  { "tummetott/unimpaired.nvim", event = "VeryLazy" },
  { "knubie/vim-kitty-navigator", event = "VeryLazy" },
  { "stevearc/oil.nvim", event = "VeryLazy", opts = {} },
  { "kiyoon/telescope-insert-path.nvim", event = "VeryLazy" },
  { "nvim-treesitter/nvim-treesitter-refactor", event = "VeryLazy" },
  { "norcalli/nvim-colorizer.lua", event = "VeryLazy" },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
}
