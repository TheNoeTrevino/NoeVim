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
          list_definitions_toc = false,
          goto_next_usage = "<C-n>",
          goto_previous_usage = "<C-p>",
        },
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = false, -- set to `false` to disable one of the mappings
        node_incremental = "<CR>",
        node_decremental = "<bs>",
        scope_incremental = "<tab>",
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
