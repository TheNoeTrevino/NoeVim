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
  vim.cmd([[
    augroup YankHighlight
      autocmd!
      autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
    augroup END
  ]])
else
  require("config.lazy")
  require("colorizer").setup()

  -- Colorscheme options to be loaded after all plugins
  vim.cmd([[
    colorscheme retrobox
    highlight TelescopePromptPrefix guifg=#ff79c6 guibg=NONE
    highlight TelescopePromptNormal guifg=#f8f8f2 guibg=NONE
    highlight TelescopePromptBorder guifg=#6272a4 guibg=NONE
    highlight TelescopePromptTitle guifg=#ffb86c guibg=NONE
    highlight TelescopeResultsBorder guifg=#6272a4 guibg=NONE
    highlight TelescopePreviewBorder guifg=#6272a4 guibg=NONE
    highlight TelescopeSelection guifg=#f8f8f2 guibg=NONE gui=bold
    highlight TelescopeNormal guifg=#f8f8f2 guibg=NONE
    highlight TelescopeResultsTitle guifg=#ffb86c guibg=NONE
    highlight TelescopePreviewTitle guifg=#ffb86c guibg=NONE
    highlight GitSignsAdd guifg=#008c00 guibg=NONE
    highlight GitSignsChange guifg=#e08300 guibg=NONE
    highlight GitSignsDelete guifg=#ff0000 guibg=NONE
    highlight GitSignsCurrentLineBlame guifg=#888888 guibg=NONE gui=italic
    highlight NeoTreeFloatBorder guifg=#6272a4 guibg=NONE
    highlight NeoTreeFloatTitle guifg=#ffb86c guibg=NONE
    highlight NormalFloat guibg=NONE
    highlight FloatBorder guifg=#6272a4 guibg=NONE
    highlight ColorColumn ctermbg=0 guibg=#090909
    highlight CursorLineNr guifg=#fcb205 guibg=NONE
    ]])
  vim.opt.cursorline = true
  vim.opt.cursorlineopt = "number"
end
