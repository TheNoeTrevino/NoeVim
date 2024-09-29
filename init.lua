---@diagnostic disable: missing-parameter
if vim.g.vscode then
  vim.api.nvim_set_keymap("o", "j", "h", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("o", "k", "j", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("o", "l", "k", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("o", ";", "l", { noremap = true, silent = true })
  vim.api.nvim_set_keymap(
    "n",
    "<esc>",
    ":noh<CR>",
    { noremap = true, silent = true, desc = "Escape and Clear hlsearch" }
  )
  vim.api.nvim_set_keymap(
    "i",
    "<esc>",
    "<esc>:noh<CR>",
    { noremap = true, silent = true, desc = "Escape and Clear hlsearch" }
  )

  vim.g.mapleader = " "

  vim.api.nvim_set_keymap("n", "<Leader>k", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
  vim.opt.clipboard = "unnamedplus"
else
  require("config.lazy")
  require("colorizer").setup({
    user_default_options = { mode = "virtualtext" },
  })

  -- Colorscheme
  vim.cmd("colorscheme gruvbox")
  vim.api.nvim_set_hl(0, "Visual", { bg = "#454545", fg = nil })
  vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = "#ff79c6", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = "#f8f8f2", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#ffb86c", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#f8f8f2", bg = nil, bold = true })
  vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "#f8f8f2", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#ffb86c", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#ffb86c", bg = nil })
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#04b004", bg = nil })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#e08300", bg = nil })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff0000", bg = nil })
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#888888", bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { fg = "#ffb86c", bg = nil })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = nil })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#090909", ctermbg = 0 })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fcb205", bg = nil })

  vim.opt.cursorline = true
  vim.opt.cursorlineopt = "number"
end
