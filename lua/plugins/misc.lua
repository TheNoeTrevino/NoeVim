return {
  { "nvim-telescope/telescope-ui-select.nvim", event = "VeryLazy" },
  { "debugloop/telescope-undo.nvim", event = "VeryLazy" },
  { "nvim-telescope/telescope-live-grep-args.nvim", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "mbbill/undotree", event = "VeryLazy" },
  { "ThePrimeagen/vim-be-good", event = "VeryLazy" },
  { "nvim-neorg/neorg-telescope", event = "VeryLazy" },
  { "tummetott/unimpaired.nvim", event = "VeryLazy" },
  { "knubie/vim-kitty-navigator", event = "VeryLazy" },
  { "stevearc/oil.nvim", event = "VeryLazy", opts = {} },
  { "kiyoon/telescope-insert-path.nvim", event = "VeryLazy" },
  { "catppuccin/nvim", name = "catppuccin", event = "VeryLazy" },
  { "rebelot/kanagawa.nvim" },
  { "rose-pine/neovim", name = "rosepine" },
  { "ellisonleao/gruvbox.nvim" },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  -- {
  --   "windwp/nvim-autopairs",
  --   event = "VeryLazy",
  --   config = true,
  --   toggle_autopairs = function()
  --     local autopairs = require("nvim-autopairs")
  --     if autopairs.state.disabled then
  --       autopairs.enable()
  --       print("nvim-autopairs enabled")
  --     else
  --       autopairs.disable()
  --       print("nvim-autopairs disabled")
  --     end
  --   end,
  -- },
}
