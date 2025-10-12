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
    event = "VeryLazy",
    config = function()
      require("wit").setup({})
      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })
    end,
  },
  "tpope/vim-fugitive",
  {
    "vyfor/cord.nvim",
    event = "VeryLazy",
    build = ":Cord update",
    -- opts = {}
  },
  -- {
  --   "Bekaboo/dropbar.nvim",
  --   event = "VeryLazy",
  --   -- optional, but required for fuzzy finder support
  --   dependencies = {
  --     "nvim-telescope/telescope-fzf-native.nvim",
  --     build = "make",
  --   },
  --   config = function()
  --     local dropbar_api = require("dropbar.api")
  --     require("dropbar").setup({
  --       sources = {
  --         path = {
  --           max_depth = 2,
  --         },
  --       },
  --     })
  --     vim.keymap.set("n", "<Leader>;", dropbar_api.pick)
  --     vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
  --     vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  --   end,
  -- },
  -- {
  --   "mizlan/iswap.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("iswap").setup({
  --       -- Highlight group for the sniping value (asdf etc.)
  --       -- default 'Search'
  --       hl_snipe = "ISwapSelection",
  --
  --       -- Highlight group for the visual selection of terms
  --       -- default 'Visual'
  --       hl_selection = "Visual",
  --
  --       -- Automatically swap with only two arguments
  --       -- default nil
  --       autoswap = true,
  --     })
  --   end,
  -- },
  {
    "shortcuts/no-neck-pain.nvim",
    event = "VeryLazy",
    version = "*",
    config = function()
      require("no-neck-pain").setup({
        width = 80,
        buffers = {
          right = {
            enabled = false,
          },
          scratchPad = {
            enabled = true,
            fileName = "neckPain",
            location = "~/notes/neckpain",
          },
          bo = {
            filetype = "md",
          },
        },
      })
    end,
  },
}
