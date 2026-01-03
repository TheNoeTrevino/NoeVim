return {
  "MeanderingProgrammer/treesitter-modules.nvim",
  lazy = true,
  opts = {
    -- fold = {
    --   enable = true,
    -- },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = false, -- set to `false` to disable one of the mappings
        node_incremental = "<CR>",
        node_decremental = "<bs>",
        scope_incremental = "<tab>",
      },
      indent = {
        enable = true,
      },
    },
  },
}
