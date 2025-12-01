return {
  -- Util
  -- { "ThePrimeagen/vim-be-good", event = "VeryLazy" },
  -- {
  --   "meznaric/key-analyzer.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("key-analyzer").setup({
  --       -- Name of the command to use for the plugin
  --       command_name = "KeyAnalyzer", -- or nil to disable the command
  --
  --       -- Customize the highlight groups
  --       highlights = {
  --         bracket_used = "KeyAnalyzerBracketUsed",
  --         letter_used = "KeyAnalyzerLetterUsed",
  --         bracket_unused = "KeyAnalyzerBracketUnused",
  --         letter_unused = "KeyAnalyzerLetterUnused",
  --         promo_highlight = "KeyAnalyzerPromo",
  --
  --         -- Set to false if you want to define highlights manually
  --         define_default_highlights = true,
  --       },
  --     })
  --   end,
  -- },
  {
    "aliqyan-21/wit.nvim",
    cmd = { "WitSearchVisual", "WitSearchWiki", "WitSearch" },
    opts = {},
  },
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },
  {
    "vyfor/cord.nvim",
    event = "VeryLazy",
    build = ":Cord update",
    -- opts = {}
  },
  {
    "andythigpen/nvim-coverage",
    version = "*",
    config = function()
      require("coverage").setup({
        auto_reload = true,
      })
    end,
  },
  {
    "AndrewRadev/linediff.vim",
    event = "UIEnter",
    config = function()
      vim.keymap.set("x", "D", function()
        return vim.fn.mode() == "V" and ":Linediff<cr>" or "D"
      end, { noremap = true, expr = true })
    end,
  },
}
