local map = LazyVim.safe_keymap_set

-------------------------------------------------------------------------------
--                           Shift Navigation Section
-------------------------------------------------------------------------------

-- better up/down
map({ "n", "x" }, "k", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "l", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Remap j; for navigation/o-pending
map({ "n", "x", "o" }, "j", "<Left>", { desc = "Right", silent = true })
map("o", "k", "<Down>", { desc = "Down", silent = true })
map("o", "l", "<Up>", { desc = "Up", silent = true })
map({ "n", "x", "o" }, ";", "<Right>", { desc = "Left", silent = true })

-- Move Lines
map("n", "<A-l>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-l>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("n", "<A-k>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("v", "<A-l>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
map("v", "<A-k>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })

-- Terminal Mappings
map("t", "<C-j>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-k>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-l>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-;>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

-------------------------------------------------------------------------------
--                           Misc/Util Section
-------------------------------------------------------------------------------

-- Add ctrl backspace
map("i", "<C-BS>", "<C-w>")

-- Better alternate buffer
map("n", "L", "<C-^>", { noremap = true, silent = true })

-- Better end and beginning
map({ "n", "x", "o" }, "-", "_", { noremap = true, silent = true })
map({ "n", "x", "o" }, "+", "$", { noremap = true, silent = true })

-- Paste without putting into clipboard
map("x", "<leader>p", [["_dP]])

map("n", "dm", [[:lua DeleteMark()<CR>]], { desc = "Delete Mark x" })

function DeleteMark()
  local mark = vim.fn.nr2char(vim.fn.getchar())
  vim.cmd("delmarks " .. mark)
end

-- Center when finding
map("n", "n", "nzzzv", { desc = "Next find and center" })
map("n", "N", "Nzzzv", { desc = "Prev find and center" })

-- Keep cursor in place when joining
map("n", "J", "mzJ`z:delm z<cr>")

-- Add a line up or down in normal mode
map("n", "go", "mzo<ESC>`z:delm z<cr>")
map("n", "gO", "mzO<ESC>`z:delm z<cr>")

-- Easier marks
map("n", "'", "<cmd>WhichKey `<cr>")

-- Matching Bracket
map({ "n", "x" }, "M", "%")
map({ "n", "x" }, "gC", "M")

-- Easier case switching
map("n", "U", "~<Left>")

-------------------------------------------------------------------------------
--                           Diagnostics Section
-------------------------------------------------------------------------------

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROsR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Diagnostics
map("n", "<leader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
map("n", "<leader>dN", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous Diagnostic" })
map("n", "<leader>da", "<cmd>Lspsaga show_workspace_diagnostics<CR>", { desc = "All Diagnostics" })
map("n", "<leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Buffer Diagaostics" })
map("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line Diagnostics" })
map("n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = "Cursor Diagnostics" })

map("n", "<leader>dta", "<cmd>Trouble diagnostics toggle<CR>", { desc = "All Diagnostics" })
map("n", "<leader>dtb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })

-------------------------------------------------------------------------------
--                           Windows Section
-------------------------------------------------------------------------------

-- Navigate Between Neovim and Kitty splits
-- Disable the default mappings from vim-kitty-navigator
map("n", "<C-j>", "<C-w>h", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w>j", { noremap = true, silent = true })
map("n", "<C-l>", "<C-w>k", { noremap = true, silent = true })
map("n", "<C-;>", "<C-w>l", { noremap = true, silent = true })

-- Resize with arrows
map("n", "<Up>", "<cmd>resize +3<cr>", { desc = "Increase Window Height" })
map("n", "<Down>", "<cmd>resize -3<cr>", { desc = "Decrease Window Height" })
map("n", "<Right>", "<cmd>vertical resize +3<cr>", { desc = "Increase Window Width" })
map("n", "<Left>", "<cmd>vertical resize -3<cr>", { desc = "Increase Window Width" })

-- Window arrangement
map("n", "<leader>wj", "<C-w>H", { desc = "Move Left" })
map("n", "<leader>wk", "<C-w>J", { desc = "Move Bottom" })
map("n", "<leader>wl", "<C-w>K", { desc = "Move Top" })
map("n", "<leader>w;", "<C-w>L", { desc = "Move Right" })
map("n", "<leader>we", "<C-w>=", { desc = "Equalize" })
