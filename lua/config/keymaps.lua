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
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>gl")
vim.keymap.del("n", "<C-F>")
vim.keymap.del("n", "<C-B>")
vim.keymap.del("n", "<leader>gl")

local map = LazyVim.safe_keymap_set

local toggle_opts = {
  border = "rounded",
  title_pos = "center",
  ui_width_ratio = 0.5,
}

local harpoon = require("harpoon")

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
map("n", "<tab>r", "<cmd>Tabby rename ", { desc = "Tab Rename" })

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
map("i", "<C-BS>", "<ESC>dbi")

-- Save
map("n", "<S-CR>", "<cmd>w<cr>")

-- Better alternate buffer
map("n", "L", "<C-^>", { noremap = true, silent = true })

-- Paste without putting into clipboard
map("x", "<leader>p", [["_dP]])

-- Definition mappings
map("n", "<leader>j", "<cmd>Lspsaga finder tyd+ref+def<CR>", { desc = "Get References" })
map("n", "gk", "<cmd>Glance definitions<cr>", { desc = "Peek Definition" })
map("n", "<leader>k", "<cmd>Glance definitions<cr>", { desc = "Peek Definition" })
map("n", "gR", "<cmd>Glance references<cr>", { desc = "Glance References" })

map("n", "dm", [[:lua DeleteMark()<CR>]], { desc = "Delete Mark x" })

function DeleteMark()
  local mark = vim.fn.nr2char(vim.fn.getchar())
  vim.cmd("delmarks " .. mark)
end

local search = require("improved-search")

-- Search current word
map("n", "!", search.current_word)

-- Search selected text in visual mode
map("x", "/", search.in_place) -- search selection without moving

-- Search by motion in place, |ib searching in the nearest pairs
map("n", "|", search.in_place)

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
map({ "n", "x" }, "M", "%")
map({ "n", "x" }, "gC", "M")

-- Easier case switching
map("n", "U", "~<Left>")

-- Better end and beginning
map({ "n", "x", "o" }, "-", "zH^", { noremap = true, silent = true })
map({ "n", "x", "o" }, "+", "$", { noremap = true, silent = true })

map({ "n", "x", "o" }, "gj", "zH^", { noremap = true, silent = true, desc = "Go to Beginnning" })
map({ "n", "x", "o" }, "g;", "$", { noremap = true, silent = true, desc = "Go to End" })

-- Portal
map("n", "<leader>;", "<CMD>Portal jumplist forward<cr>", { silent = true })
map("n", "<leader>l", "<CMD>Portal jumplist backward<cr>", { silent = true })

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

map("n", "<leader>da", "<cmd>Trouble diagnostics toggle<CR>", { desc = "All Diagnostics" })
map("n", "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })

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

-------------------------------------------------------------------------------
--                           Toggle Section
-------------------------------------------------------------------------------

-- Toggle Transparency
map("n", "<leader>0", "<cmd>TransparentToggle<CR>", { desc = "Transparency" })

-- Toggle ZenMode
map("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Transparency" })

-------------------------------------------------------------------------------
--                           Scrolling Section
-------------------------------------------------------------------------------

local neoscroll = require("neoscroll")
neoscroll.setup({
  easing = "quadratic",
})
local keymap = {
  ["<C-u>"] = function()
    neoscroll.ctrl_u({ duration = 150 })
  end,
  ["<C-d>"] = function()
    neoscroll.ctrl_d({ duration = 150 })
  end,
  ["<C-b>"] = function()
    neoscroll.ctrl_b({ duration = 200 })
  end,
  ["<C-f>"] = function()
    neoscroll.ctrl_f({ duration = 200 })
  end,
  ["<C-y>"] = function()
    neoscroll.scroll(-0.1, { move_cursor = true, duration = 100 })
  end,
  ["<C-e>"] = function()
    neoscroll.scroll(0.1, { move_cursor = true, duration = 100 })
  end,
  ["zt"] = function()
    neoscroll.zt({ half_win_duration = 100 })
  end,
  ["zz"] = function()
    neoscroll.zz({ half_win_duration = 150 })
  end,
  ["zb"] = function()
    neoscroll.zb({ half_win_duration = 100 })
  end,
}
local modes = { "n", "v", "x" }
for key, func in pairs(keymap) do
  vim.keymap.set(modes, key, func)
end

-------------------------------------------------------------------------------
--                           Database Section
-------------------------------------------------------------------------------

map(
  "n",
  "<localleader>do",
  "<cmd>tabnew<cr><cmd>Tabby rename_tab Database<cr><cmd>DBUIToggle<CR>",
  { desc = "Open Database" }
)
map("n", "<localleader>du", "<cmd>DBUIToggle<CR>", { desc = "Toggle Database" })
map("n", "<localleader>df", "<cmd>DBUIFindBuffer<CR>", { desc = "Find Buffer" })

-------------------------------------------------------------------------------
--                           Markdown Section
-------------------------------------------------------------------------------

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "which_key_ignore" })

-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
map("n", "<CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
  end
end, { desc = "[P]Toggle fold" })

local function set_foldmethod_expr()
  -- These are lazyvim.org defaults but setting them just in case a file
  -- doesn't have them set
  if vim.fn.has("nvim-0.10") == 1 then
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
    vim.opt.foldtext = ""
  else
    vim.opt.foldmethod = "indent"
    vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
  end
  vim.opt.foldlevel = 99
end

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd("normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Fold the heading if it matches the level
      if vim.fn.foldclosed(line) == -1 then
        vim.cmd("normal! za")
      end
    end
  end
end

local function fold_markdown_headings(levels)
  set_foldmethod_expr()
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- Keymap for unfolding markdown headings of level 2 or above
map("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
end, { desc = "Unfold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 1 or above
map("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
end, { desc = "Fold all headings level 1 or above" })

-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
map("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
end, { desc = "Fold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 3 or above
map("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
end, { desc = "Fold all headings level 3 or above" })

-- Keymap for folding markdown headings of level 4 or above
map("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
end, { desc = "Fold all headings level 4 or above" })
