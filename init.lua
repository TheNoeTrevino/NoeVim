-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.cmd("colorscheme kanagawa-dragon")
-- Current line number colors
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#c9c5c9" })
-- enable cursorline and set cursorlineopt to number
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
