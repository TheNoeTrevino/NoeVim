-- Vendored Util default options (loaded first, mirrors Util load order: defaults
-- then user). The user overrides below win. Sets vim.g.mapleader etc.
require("config.defaults.options")

-- Add any additional options here
vim.g.moonflyItalics = false

vim.g.gruvbox_material_enable_italic = false

vim.g.gruvbox_material_disable_italic_comment = 1

vim.g.gruvbox_contrast_dark = "hard"

vim.g.gruvbox_material_background = "hard"

vim.g.sonokai_style = "shusia"
vim.g.sonokai_better_performance = 1

-- vim.opt.textwidth = 80

vim.opt.listchars = {
  tab = "  ",
  trail = " ",
  nbsp = "+",
}

vim.g.maplocalleader = ","

vim.opt.termguicolors = true

-- Default is 4
vim.opt.sidescrolloff = 0

-- In case you don't want to use `:LazyExtras`,
-- then you need to set the option below.
vim.g.lazyvim_picker = "snacks"

vim.g.db_ui_use_nerd_fonts = 1

vim.opt.smartindent = true

vim.o.cmdheight = 0

-- vim.cmd([[ autocmd RecordingEnter * set cmdheight=1 ]])
-- vim.cmd([[ autocmd RecordingLeave * set cmdheight=0 ]])

vim.o.winborder = "single"

vim.highlight.priorities.semantic_tokens = 95 -- default is 125
vim.highlight.priorities.treesitter = 100 -- default is 100

vim.opt.shortmess:remove("I")

vim.o.exrc = true
vim.o.secure = true

vim.g.lazyvim_rust_diagnostics = "bacon-ls"
