return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-refactor",
  },
  opts = {
    refactor = {
      highlight_definitions = { enable = false },
      navigation = {
        enable = true,
        keymaps = {
          goto_next_usage = "<C-n>",
          goto_previous_usage = "<C-p>",
        },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
