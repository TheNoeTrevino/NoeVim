-- Remove LazyVim Mappings
vim.keymap.del("n", "<leader>`")
vim.keymap.del("n", "<leader>|")
vim.keymap.del("n", "<leader>-")
vim.keymap.del("n", "<leader>L")
vim.keymap.del("n", "<leader>l")
vim.keymap.del("n", "<leader>K")
-- vim.keymap.del("n", "<leader>snt")
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
vim.keymap.del("n", "<leader>uD")
vim.keymap.del("t", "<c-/>")
vim.keymap.del("n", "<c-/>")
vim.keymap.del("t", "<c-_>")
vim.keymap.del("n", "<c-_>")
vim.keymap.del("n", "L")
vim.keymap.del("n", "<c-k>")
vim.keymap.del("n", "<leader>bb")
vim.keymap.del("n", "<leader>bD")
vim.keymap.del("n", "<leader>bd")
vim.keymap.del("n", "<leader>bo")
-- vim.keymap.del("n", "<c-p>")

local map = LazyVim.safe_keymap_set

-------------------------------------------------------------------------------
--                          Treesitter Navigation Section
-------------------------------------------------------------------------------

local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

-- custom moves
map({ "n", "x", "o" }, "]a", function()
  move.goto_next_start("@parameter.inner", "textobjects")
end, { desc = "Next Parameter Start" })
map({ "n", "x", "o" }, "]A", function()
  move.goto_next_end("@parameter.inner", "textobjects")
end, { desc = "Next Parameter End" })

map({ "n", "x", "o" }, "[a", function()
  move.goto_previous_start({ "@parameter.inner", "@loop.outer" }, "textobjects")
end, { desc = "Previous Parameter Start" })

map({ "n", "x", "o" }, "[A", function()
  move.goto_previous_end("@parameter.inner", "locals")
end, { desc = "Previous Parameter End" })

-- custom swaps
map("n", "_a", function()
  swap.swap_next("@parameter.inner")
end, { desc = "Swap with Next Param" })

map("n", "_A", function()
  swap.swap_previous("@parameter.inner")
end, { desc = "Swap with Prev Param" })

map("n", "_f", function()
  swap.swap_next("@function.outer")
end, { desc = "Swap with Next Func" })

map("n", "_F", function()
  swap.swap_previous("@function.outer")
end, { desc = "Swap with Next Func" })

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

-- Windows
map("n", "<c-j>", "<c-w>h", { desc = "Move Left" })
map("n", "<c-k>", "<c-w>j", { desc = "Move Down" })
map("n", "<c-l>", "<c-w>k", { desc = "Move Up" })
map("n", "<c-;>", "<c-w>l", { desc = "Move Right" })

-- -- Terminal Mappings
-- map("i", "<C-j>", function()
--   vim.cmd.stopinsert()
--   vim.cmd("wincmd h")
-- end, { desc = "Go to Left Window" })
--
-- map("t", "<C-j>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
-- map("t", "<C-k>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
-- map("t", "<C-l>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
-- map("t", "<C-;>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

-- TMUX
map("n", "<c-_>", function()
  require("sidekick.cli").toggle()
end, { desc = "Opencode" })

-- idk man, windows
map("n", "", function()
  require("sidekick.cli").toggle()
end, { desc = "Opencode" })

map({ "n", "t" }, "<c-\\>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  -- require("copilot.suggestion").dismiss()
  LazyVim.cmp.actions.snippet_stop()
  -- vim.cmd("Sidekick nes clear")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

map("n", "zj", "5zh", { desc = "Scroll Left" })
map("n", "z;", "5zl", { desc = "Scroll right" })

-------------------------------------------------------------------------------
--                           Buffers Sectiokeyn
-------------------------------------------------------------------------------

-- Better alternate buffer
-- map("n", "L", "<C-^>", { noremap = true, silent = true })
map("n", "<C-,>", "<cmd>bp<cr>", { noremap = true, silent = true, desc = "Previous Buffer" })
map("n", "<C-.>", "<cmd>bn<cr>", { noremap = true, silent = true, desc = "Next Buffer" })

-------------------------------------------------------------------------------
--                           Misc/Util Section
-------------------------------------------------------------------------------

-- Highlights
for i = 1, 9 do
  map("v", "h" .. i, ":<c-u>HSHighlight " .. i .. "<CR>", {
    noremap = true,
    desc = "Highlight " .. i,
  })
end

map("v", "h0", ":<c-u>HSRmHighlight<CR>", {
  noremap = true,
  desc = "No Highlight",
})

-- Add ctrl backspace
map("i", "<C-BS>", "<ESC>cb")

-- wsl thing
map("n", "<leader>dM", ":%s/\\r//")

-- Save
map("n", "<S-CR>", "<cmd>w<cr>")

-- No right ctrl on the macbook :(
map("n", "Q", "<C-Z>", { noremap = true, silent = true })

-- Paste without putting into clipboard
map("x", "<leader>p", [["_dP]])
map("x", "<leader>d", [["_d]])

map("n", "<leader>ax", "<cmd>AvanteClear<cr>")

-- Definition mappings
map("n", "gk", "<cmd>Glance definitions<cr>", { desc = "Glance Definition" })
map("n", "gR", "<cmd>Glance references<cr>", { desc = "Glance References" })
map("n", "gY", "<cmd>Glance type_definitions<cr>", { desc = "Glance Type" })

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
map({ "n", "x", "v", "o" }, "M", "%")

map({ "n", "x", "v" }, "L", "<C-^>")

-- Easier case switching
map("n", "U", "~<Left>")

map(
  { "n", "x", "o" },
  "g.",
  "g;",
  { noremap = true, silent = true, desc = "Go to [count] older position in the change list" }
)

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
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROsR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Diagnostics
map("n", "<leader>xl", "<cmd>lua vim.diagnostic.open_float() <CR>", { desc = "Line Diagnostics" })

map("n", "<leader>xa", "<cmd>Trouble diagnostics toggle auto_jump=true focus=true<CR>", { desc = "All Diagnostics" })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>", { desc = "Buffer Diagnostics" })

-------------------------------------------------------------------------------
--                           Windows Section
-------------------------------------------------------------------------------

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
map("n", "<leader>wT", "<C-w>T", { desc = "Split Into Tab" })

map("n", "<leader>we", "<C-w>=", { desc = "Equalize" })

-- map("n", "<c-n>", "<cmd>bn<cr>")
-- map("n", "<c-p>", "<cmd>bp<cr>")

-------------------------------------------------------------------------------
--                           Jumplist Section
-------------------------------------------------------------------------------

map("n", "<C-o>", "<C-i>", { desc = "Jumplist Backwards" })

-------------------------------------------------------------------------------
--                           Toggle Section
-------------------------------------------------------------------------------

-- Code Lens
map("n", "<leader>ut", "<cmd>LenslineToggle<cr>", { desc = "Toggle Gutter" })

-- Buffer diagnostics
map("n", "<leader>uD", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }), {
    bufnr = 0,
  })
end, { desc = "Toggle Diagnostics (Buffer)" })

map("n", "<leader>ub", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }), {
    bufnr = 0,
  })
  vim.cmd("lua vim.b.autoformat = not vim.b.autoformat")
end, { desc = "Toggle Formating and Diagnotics (Buffer)" })

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

map("n", "<localleader>d", function()
  vim.cmd("tabnew")
  vim.cmd("Dbee open")
end, { desc = "Find Buffer" })

-------------------------------------------------------------------------------
--                           Markdown Section
-------------------------------------------------------------------------------

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "which_key_ignore" })
