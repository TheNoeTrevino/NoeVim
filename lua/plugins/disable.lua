return {
  { "nvim-mini/mini.pairs", enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },
  { "MagicDuck/grug-far.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  { "venv-selector.nvim", enabled = false },
  { "catppuccin", enabled = false },
  { "omnisharp-extended-lsp.nvim", enabled = false },
  { "folke/persistence.nvim", enabled = true },
  { "nvimdev/dashboard-nvim", enabled = false },
  {
    "folke/todo-comments.nvim",
    enabled = true,
  },
  {
    "EvWilson/spelunk.nvim",
    enabled = vim.fn.has("win32") == 0,
  },
  {
    "nvimtools/hydra.nvim",
    enabled = vim.fn.has("win32") == 0,
  },
  {
    "mfussenegger/nvim-dap",
    enabled = vim.fn.has("win32") == 0,
  },
  {
    "rcarriga/nvim-dap-ui",
    enabled = vim.fn.has("win32") == 0,
  },
  {
    "mfussenegger/nvim-dap-python",
    enabled = vim.fn.has("win32") == 0,
  },
  {
    "mason-nvim-dap.nvim",
    enabled = vim.fn.has("win32") == 0,
  },
}
