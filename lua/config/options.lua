-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.g.moonflyItalics = false

vim.opt.textwidth = 80

vim.opt.listchars = {
  tab = "> ",
  trail = " ",
  nbsp = "+",
}

vim.opt.foldlevel = 99
vim.opt.foldcolumn = "3"
vim.g.lazyvim_statuscolumn = {
  folds_open = true, -- show fold sign when fold is open
  folds_githl = true, -- highlight fold sign with git sign color
}

vim.g.gruvbox_material_enable_italic = false

vim.g.gruvbox_material_disable_italic_comment = 1
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_material_background = "hard"
-- vim.opt.shortmess:append("I")

-- vim.opt.colorcolumn = "80,100,120"
