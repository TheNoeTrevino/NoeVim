return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  name = "gruvbox",
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
      contrast = "hard", -- can be "hard", "soft" or empty string
      overrides = {
        CursorLine = { bg = "#000000" },
      },
      dim_inactive = false,
      transparent_mode = true,
    })
    vim.cmd("hi Underlined guifg=#ff0000 gui=underline")
    vim.cmd([[colorscheme gruvbox]])
  end,
}
