return {
  { "nvim-mini/mini.pairs", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "MagicDuck/grug-far.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  { "venv-selector.nvim", enabled = false },
  { "catppuccin", enabled = false },
  { "omnisharp-extended-lsp.nvim", enabled = false },
  { "nvimdev/dashboard-nvim", enabled = false },
  {
    "folke/persistence.nvim",
    enabled = vim.fn.has("win32") == 0,
  },
  {
    "folke/ts-comments.nvim",
    enabled = vim.fn.has("win32") == 0,
  },
  {
    "tpope/vim-dadbod",
    enabled = vim.fn.has("win32") == 0,
  },
  {
    "folke/tokyonight.nvim",
    enabled = true,
  },
  {
    "nvim-dap-python",
    enabled = vim.fn.has("win32") == 0,
  },
}
