-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- vim.cmd("colorscheme kanagawa-dragon")
-- Current line number colors
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#c9c5c9" })
-- enable cursorline and set cursorlineopt to number
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.cmd("hi Normal guibg=black")
vim.cmd("hi IlluminatedWordText gui=underline")
vim.cmd("hi IlluminatedWordRead gui=underline")
vim.cmd("hi IlluminatedWordWrite gui=underline")
-- if you wanted to change the background of the highlighted words, use this:
-- guibg=#504945
-- if you want underlines, use this instead:
-- gui=underline
-- vim.cmd("hi Normal guibg=black")
-- vim.cmd("hi Normal guibg=black")
--
--

local map = vim.keymap.set

-- Next search result
map("n", "n", "'nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'nn'[v:searchforward]", { expr = true, desc = "Next search result" })

-- Previous search result
map("n", "N", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Previous search result" })
map("x", "N", "'Nn'[v:searchforward]", { expr = true, desc = "Previous search result" })
map("o", "N", "'Nn'[v:searchforward]", { expr = true, desc = "Previous search result" })
