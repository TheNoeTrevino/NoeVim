return {
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   name = "kanagawa",
  --   priority = 1000,
  --   config = function()
  --     -- Setup Kanagawa colorscheme with custom highlights
  --     require("kanagawa").setup({
  --       colors = {
  --         palette = {
  --           sumiInk0 = "#000000",
  --           fujiWhite = "#FFFFFF",
  --         },
  --         theme = {
  --           wave = {
  --             ui = {
  --               float = {
  --                 bg = "none",
  --               },
  --             },
  --           },
  --           dragon = {
  --             syn = {
  --               parameter = "#7cdcfe", -- Set parameter color to yellow using hex code
  --             },
  --             ui = {
  --               bg_gutter = "none",
  --             },
  --           },
  --           all = {
  --             ui = {
  --               bg_gutter = "none",
  --             },
  --           },
  --         },
  --         overrides = {
  --           Normal = { bg = "#1f1f1f" },
  --           Visual = { bg = "#575D6B" },
  --         },
  --       },
  --     })
  --     -- Apply the colorscheme
  --     vim.cmd.colorscheme("kanagawa-dragon")
  --     --
  --     -- Apply custom highlights to ensure they override the defaults
  --     vim.api.nvim_set_hl(0, "Comment", { italic = false, fg = "#425d37" })
  --     vim.api.nvim_set_hl(0, "Keyword", { italic = false, fg = "#c586c0" })
  --     vim.api.nvim_set_hl(0, "Number", { fg = "#b5cea8", italic = false })
  --     vim.api.nvim_set_hl(0, "Boolean", { fg = "#569CD6", italic = false })
  --     vim.api.nvim_set_hl(0, "String", { fg = "#CE9178", italic = false })
  --     -- vim.api.nvim_set_hl(0, "Identifier", { fg = "#2cf651" }) -- does not work
  --     vim.api.nvim_set_hl(0, "Field", { fg = "#2cc1e5" }) -- Fields of tables
  --     vim.api.nvim_set_hl(0, "Function", { fg = "#dcdcaa" }) -- Functions
  --     vim.api.nvim_set_hl(0, "Method", { fg = "#dcdcaa" })
  --
  --     -- -- visual mode
  --     vim.api.nvim_set_hl(0, "Visual", { bg = "#2a2a2a" })
  --   end,
  -- },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    name = "gruvbox",
    priority = 1000,
    config = function()
      -- Disable italics in gruvbox
      vim.g.gruvbox_italic = 0

      require("gruvbox").setup({
        terminal_colors = false, -- add neovim terminal colors
        undercurl = false,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          operators = false,
          folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "hard", -- can be "hard", "soft" or empty string
        palette_overrides = { dark0_hard = "#000000" },
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      })
      vim.cmd("hi Underlined guifg=#ff0000 gui=underline")
      vim.cmd([[colorscheme gruvbox]])
      vim.cmd("hi Normal guibg=black")
    end,
  },
}
