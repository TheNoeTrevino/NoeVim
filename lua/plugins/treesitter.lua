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
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<Leader>ys", -- set to `false` to disable one of the mappings
        node_incremental = "<leader><leader>",
        node_decremental = "<bs>",
        scope_incremental = false,
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
