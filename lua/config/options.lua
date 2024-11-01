-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.moonflyItalics = false

vim.g.gruvbox_material_enable_italic = false

vim.g.gruvbox_material_disable_italic_comment = 1

vim.g.gruvbox_contrast_dark = "hard"

vim.g.gruvbox_material_background = "hard"

vim.g.sonokai_style = "shusia"
vim.g.sonokai_better_performance = 1

vim.opt.textwidth = 80

vim.opt.listchars = {
  tab = "> ",
  trail = " ",
  nbsp = "+",
}

vim.opt.termguicolors = true

-- Default is 4
vim.opt.sidescrolloff = 0

-- Hover Docs Aesthetics
local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
  opts = vim.tbl_extend("keep", opts or {}, { border = border })
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
