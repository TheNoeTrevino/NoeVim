return {
  { "rose-pine/neovim", name = "rose-pine" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "rebelot/kanagawa.nvim" },
  { "ChristianChiarulli/nvcode-color-schemes.vim" },
  { "nanotee/zoxide.vim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "debugloop/telescope-undo.nvim" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  { "tpope/vim-repeat" },
  {
    "vhyrro/luarocks.nvim",
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "chentoast/marks.nvim",
    config = function()
      vim.cmd("highlight MarkSignHL guifg=#FF0000")
      require("marks").setup({
        default_mappings = true,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  {
    "tummetott/unimpaired.nvim",
    config = function()
      require("unimpaired").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "tummetott/unimpaired.nvim",
    config = function()
      require("unimpaired").setup()
    end,
  },
  { --removing the highlighing of words and letting illuminate do it. Reconsider for sure
    "neovim/nvim-lspconfig",
    opts = {
      document_highlight = {
        enabled = true,
      },
    },
  }, -- {
  --   "kevinhwang91/nvim-ufo",
  --   dependencies = {
  --     "kevinhwang91/promise-async",
  --   },
  -- },
}
