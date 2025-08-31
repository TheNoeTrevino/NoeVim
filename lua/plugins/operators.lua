return {
  "nvim-mini/mini.operators",
  version = false,
  config = function()
    require("mini.operators").setup({

      evaluate = {
        prefix = "g=",
      },

      exchange = {
        prefix = "gX",
        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },

      -- Multiply (duplicate) text
      multiply = {
        prefix = "gm",
      },

      -- Replace text with register
      replace = {
        -- NOTE: Default `gr*` LSP mappings are removed
        prefix = "gr",

        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },

      -- Sort text
      sort = {
        prefix = "gs",
      },
    })
  end,
}
