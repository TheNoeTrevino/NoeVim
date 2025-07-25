-- Remove LazyVim Mappings
vim.keymap.del("n", "<leader>`")
vim.keymap.del("n", "<leader>|")
vim.keymap.del("n", "<leader>-")
vim.keymap.del("n", "<leader>L")
vim.keymap.del("n", "<leader>l")
vim.keymap.del("n", "<leader>K")
vim.keymap.del("n", "<leader>snt")
vim.keymap.del("n", "<leader>st")
vim.keymap.del("n", "<leader><Tab>[")
vim.keymap.del("n", "<leader><Tab>]")
vim.keymap.del("n", "<leader><Tab>d")
vim.keymap.del("n", "<leader><Tab>l")
vim.keymap.del("n", "<leader><Tab>o")
vim.keymap.del("n", "<leader><Tab>f")
vim.keymap.del("n", "<leader><Tab><tab>")
vim.keymap.del("i", ",")
vim.keymap.del("i", ".")
vim.keymap.del("i", ";")
vim.keymap.del("n", "<leader>fn")
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>xl")
vim.keymap.del("n", "<leader>xq")
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<leader>gl")
vim.keymap.del("n", "<C-F>")
vim.keymap.del("n", "<C-B>")
vim.keymap.del("n", "<leader>uG")

local map = LazyVim.safe_keymap_set

----------------------------------------------------------------------------
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
--                           Tab Section
-------------------------------------------------------------------------------

map("n", "<tab><tab>", "<cmd>tabnew<cr>", { desc = "Tab New" })
map("n", "<tab>j", "<cmd>tabn<cr>", { desc = "Tab Next" })
map("n", "<tab>;", "<cmd>tabp<cr>", { desc = "Tab Prev" })
map("n", "<tab>n", "<cmd>tabn<cr>", { desc = "Tab Next" })
map("n", "<tab>p", "<cmd>tabp<cr>", { desc = "Tab Prev" })
map("n", "<tab>c", "<cmd>tabc<cr>", { desc = "Tab Close" })
map("n", "<tab>q", "<cmd>tabc<cr>", { desc = "Tab Close" })
map("n", "<tab>q", "<cmd>tabc<cr>", { desc = "Tab Close" })
map("n", "<tab>r", ":TabRename", { desc = "Tab Rename" })

-------------------------------------------------------------------------------
--                           Misc/Util Section
-------------------------------------------------------------------------------

-- Highlights
for i = 1, 9 do
  map("v", "h" .. i, ":<c-u>HSHighlight " .. i .. "<CR>", {
    noremap = true,
    silent = true,
  })
end

map("v", "h0", ":<c-u>HSRmHighlight<CR>", {
  noremap = true,
  silent = true,
})

-- Add ctrl backspace
map("i", "<C-BS>", "<ESC>cb")

-- Save
map("n", "<S-CR>", "<cmd>w<cr>")

-- Better alternate buffer
map("n", "L", "<C-^>", { noremap = true, silent = true })

-- No right ctrl on the macbook :(
map("n", "Q", "<C-Z>", { noremap = true, silent = true })

-- Paste without putting into clipboard
map("x", "<leader>p", [["_dP]])
map("x", "<leader>d", [["_d]])

map("n", "<leader>ax", "<cmd>AvanteClear<cr>")

-- Definition mappings
map("n", "gk", "<cmd>Glance definitions<cr>", { desc = "Peek Definition" })
map("n", "gR", "<cmd>Glance references<cr>", { desc = "Glance References" })

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
map("n", "go", "mzo<ESC>`z:delm z<cr><down>")
map("n", "gO", "mzO<ESC>`z:delm z<cr><up>")

-- Easier marks
map("n", "'", "<cmd>WhichKey `<cr>")

-- Matching Bracket
map("n", "M", "<Plug>(MatchitNormalForward)")
map({ "x", "v" }, "M", "%")

-- Easier case switching
map("n", "U", "~<Left>")

-- Better end and beginning
map({ "n", "x", "o" }, "gj", "zH^", { noremap = true, silent = true, desc = "Go to Beginnning" })
map({ "n", "x", "o" }, "g;", "$", { noremap = true, silent = true, desc = "Go to End" })

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
map("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line Diagnostics" })
map("n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = "Cursor Diagnostics" })

map("n", "<leader>da", "<cmd>Trouble diagnostics toggle auto_jump=true focus=true<CR>", { desc = "All Diagnostics" })
map("n", "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>", { desc = "Buffer Diagnostics" })

-------------------------------------------------------------------------------
--                           Windows Section
-------------------------------------------------------------------------------

-- Navigate Between Neovim and Kitty splits
-- Disable the default mappings from vim-kitty-navigator
vim.g.kitty_navigator_no_mappings = 1
map("n", "<C-j>", ":KittyNavigateLeft<CR>", { noremap = true, silent = true })
map("n", "<C-k>", ":KittyNavigateDown<CR>", { noremap = true, silent = true })
map("n", "<C-l>", ":KittyNavigateUp<CR>", { noremap = true, silent = true })
map("n", "<C-;>", ":KittyNavigateRight<CR>", { noremap = true, silent = true })

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

map("n", "<leader>we", "<C-w>=", { desc = "Equalize" })

map("n", "<c-n>", "<cmd>bn<cr>")
map("n", "<c-p>", "<cmd>bp<cr>")

-------------------------------------------------------------------------------
--                           Jumplist Section
-------------------------------------------------------------------------------

map("n", "\\", "<C-o>", { desc = "Jumplist Forwards" })
map("n", "<C-o>", "<C-i>", { desc = "Jumplist Backwards" })

-------------------------------------------------------------------------------
--                           Toggle Section
-------------------------------------------------------------------------------

-- Toggle Transparency
map("n", "<leader>0", "<cmd>TransparentToggle<CR>", { desc = "Transparency" })

-- Toggle ZenMode
map("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Transparency" })

-- Toggle Gutter
map("n", "<leader>uG", "<cmd>ToggleGutter<CR>", { desc = "Toggle Gutter" })

-------------------------------------------------------------------------------
--                           Database Section
-------------------------------------------------------------------------------

map(
  "n",
  "<localleader>,",
  "<cmd>tabnew<cr><cmd>Tabby rename_tab Database<cr><cmd>DBUIToggle<CR>",
  { desc = "Open Database" }
)
map("n", "<localleader>u", "<cmd>DBUIToggle<CR>", { desc = "Toggle Database" })
map("n", "<localleader>f", "<cmd>DBUIFindBuffer<CR>", { desc = "Find Buffer" })

-------------------------------------------------------------------------------
--                           Markdown Section
-------------------------------------------------------------------------------

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "which_key_ignore" })
