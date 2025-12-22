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
  {
    "esmuellert/vscode-diff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
    opts = {
      highlights = {
        -- Line-level: accepts highlight group names or hex colors (e.g., "#2ea043")
        line_insert = "#1B2018",
        line_delete = "#2A151A", -- Line-level deletions

        char_brightness = 1.5, -- Auto-adjust based on your colorscheme
      },
      -- Override character colors explicitly
      -- highlights = {
      --   line_insert = "DiffAdd",
      --   line_delete = "DiffDelete",
      --   char_insert = "#1a4d1a",
      --   char_delete = "#ff7b72",
      -- },
    },
  },
}
