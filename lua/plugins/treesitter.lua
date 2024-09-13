return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = {
        enable = false, -- disable default highlight
      },
      refactor = {
        highlight_definitions = { enable = false }, -- disable default highlighting for definitions
        highlight_current_scope = { enable = false }, -- disable scope highlighting
        navigation = {
          enable = true,
          keymaps = {
            goto_definition_lsp_fallback = "gd",
            list_definitions = "gnD",
            list_definitions_toc = "gO",
            goto_next_usage = "<C-n>",
            goto_previous_usage = "<C-p>",
          },
        },
      },
    })
  end,
}
