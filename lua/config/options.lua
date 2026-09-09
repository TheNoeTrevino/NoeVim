-- Load the default options first (so the overrides below win), then the personal ones.
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

-- Neovim's built-in cmdline/message UI, the replacement for noice.nvim. It keeps the cmdline at
-- the bottom and highlights it with treesitter: `:lua ...` gets the vim grammar's lua injection,
-- which is the one noice feature worth keeping. It also takes over message rendering, since it
-- attaches with ext_messages = true -- there is no cmdline-only mode. `g<` opens the pager.
-- Experimental and on a private path, so a nightly rename will error loudly here.

-- Messages stay on the cmdline (the default target). ui2 collapses anything longer than
-- 'cmdheight' behind a `[+x]` spill indicator rather than a hit-enter prompt, so cmdheight = 0
-- costs no "Press ENTER" interruptions. `g<` opens the pager to read a collapsed message.
require("vim._core.ui2").enable({})

vim.o.winborder = "single"

vim.highlight.priorities.semantic_tokens = 95 -- default is 125
vim.highlight.priorities.treesitter = 100 -- default is 100

vim.opt.shortmess:remove("I")

vim.o.exrc = true
vim.o.secure = true

vim.g.lazyvim_rust_diagnostics = "bacon-ls"

-- Highlight only the line number of the cursor line.
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.filetype.add({
  extension = {
    mustache = "html",
  },
})
