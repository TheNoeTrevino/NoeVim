if vim.g.vscode then
  vim.api.nvim_set_keymap("n", "j", "h", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "k", "j", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "l", "k", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", ";", "l", { noremap = true, silent = true })

  vim.api.nvim_set_keymap("v", "j", "h", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "k", "j", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "l", "k", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", ";", "l", { noremap = true, silent = true })

  vim.api.nvim_set_keymap("x", "j", "h", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("x", "k", "j", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("x", "l", "k", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("x", ";", "l", { noremap = true, silent = true })

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

  -- Map <Leader>gr to get references
  vim.api.nvim_set_keymap("n", "<Leader>gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
  vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
  -- Highlight yanked text for a brief time
  vim.cmd([[
    augroup YankHighlight
      autocmd!
      autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
    augroup END
  ]])
else
  require("config.lazy")
end
