return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      preset = "classic",
      transparent_bg = true,
      transparent_cursorline = true, -- keep cursorline transparent
      options = {
        show_all_diags_on_cursorline = true, -- show all diagnostics on the current line
        show_diags_only_under_cursor = false, -- show diagnostics even when not directly under cursor
        enable_on_insert = true, -- optional: show while in insert mode
        multilines = { enabled = true, always_show = true },
        show_source = {
          enabled = true,
        },
        -- multilines = {
        --   enabled = false, -- Enable support for multiline diagnostic messages
        --   always_show = false, -- Always show messages on all lines of multiline diagnostics
        --   trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
        --   tabstop = 4, -- Number of spaces per tab when expanding tabs
        --   severity = nil, -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
        -- },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { diagnostics = { virtual_text = false } },
  },
}
