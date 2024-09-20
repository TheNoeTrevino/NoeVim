local map = LazyVim.safe_keymap_set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Remap jkl; for navigation
map({ "n", "x" }, "j", "h", { desc = "Right", silent = true })
map({ "n", "x" }, "k", "j", { desc = "Down", silent = true })
map({ "n", "x" }, "l", "k", { desc = "Up", silent = true })
map({ "n", "x" }, ";", "l", { desc = "Left", silent = true })

-- Move Lines
map("n", "<A-l>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-l>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("n", "<A-k>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("v", "<A-l>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
map("v", "<A-k>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })

-- Delete Lines
map("n", "dk", "Vjd", { desc = "Delete current and below line" })
map("n", "dl", "Vkd", { desc = "Delete current and above line" })

-- Add ctrl backspace
map("i", "<C-BS>", "<C-w>")

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "n" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- formatting
map({ "n", "v" }, "<leader>cf", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start
-- toggle options
map("n", "<leader>ut", "<cmd>UndotreeToggle<cr>", { desc = "Go to Left Window" })
LazyVim.toggle.map("<leader>uf", LazyVim.toggle.format())
LazyVim.toggle.map("<leader>uF", LazyVim.toggle.format(true))
LazyVim.toggle.map("<leader>us", LazyVim.toggle("spell", { name = "Spelling" }))
LazyVim.toggle.map("<leader>uw", LazyVim.toggle("wrap", { name = "Wrap" }))
LazyVim.toggle.map("<leader>uL", LazyVim.toggle("relativenumber", { name = "Relative Number" }))
LazyVim.toggle.map("<leader>ud", LazyVim.toggle.diagnostics)
LazyVim.toggle.map("<leader>ul", LazyVim.toggle.number)
LazyVim.toggle.map( "<leader>uc", LazyVim.toggle("conceallevel", { values = { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 2 } }))
LazyVim.toggle.map("<leader>uT", LazyVim.toggle.treesitter)
LazyVim.toggle.map("<leader>ub", LazyVim.toggle("background", { values = { "light", "dark" }, name = "Background" }))
if vim.lsp.inlay_hint then
  LazyVim.toggle.map("<leader>uh", LazyVim.toggle.inlay_hints)
end

-- lazygit
map("n", "<leader>gg", function() LazyVim.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
map("n", "<leader>gG", function() LazyVim.lazygit() end, { desc = "Lazygit (cwd)" })
map("n", "<leader>gb", LazyVim.lazygit.blame_line, { desc = "Git Blame Line" })
map("n", "<leader>gB", LazyVim.lazygit.browse, { desc = "Git Browse" })

map("n", "<leader>gf", function()
  local git_path = vim.api.nvim_buf_get_name(0)
  LazyVim.lazygit({args = { "-f", vim.trim(git_path) }})
end, { desc = "Lazygit Current File History" })

map("n", "<leader>gl", function()
  LazyVim.lazygit({ args = { "log" }, cwd = LazyVim.root.git() })
end, { desc = "Lazygit Log" })
map("n", "<leader>gL", function()
  LazyVim.lazygit({ args = { "log" } })
end, { desc = "Lazygit Log (cwd)" })

-- LazyVim Changelog
map("n", "<leader>L", function() LazyVim.news.changelog() end, { desc = "LazyVim Changelog" })


-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-j>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-k>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-l>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-;>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Windows
LazyVim.toggle.map("<leader>m", LazyVim.toggle.maximize)

-- Move to window using the <ctrl> hjkl keys
-- map("n", "<C-j>", "<C-w>h", { desc = "Go to Left Window", remap = true })
-- map("n", "<C-k>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
-- map("n", "<C-l>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
-- map("n", "<C-;>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Disable the default mappings from vim-kitty-navigator
vim.g.kitty_navigator_no_mappings = 1

-- Navigate Between Neovim and Kitty splits
map('n', '<C-j>', ':KittyNavigateLeft<CR>', { noremap = true, silent = true})
map('n', '<C-k>', ':KittyNavigateDown<CR>', { noremap = true, silent = true})
map('n', '<C-l>', ':KittyNavigateUp<CR>', { noremap = true, silent = true})
map('n', '<C-;>', ':KittyNavigateRight<CR>', { noremap = true, silent = true})

-- for some reason these do not work in the other. Super weird
-- Resize window using <ctrl> nav keys (for arch)
map("n", "<C-M-l>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-M-k>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-M-j>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-M-;>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Resize window using <ctrl><shift> nav keys (for mac)
map("n", "<C-S-l>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-S-k>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-S-j>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-S-;>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Better alternate tab
map('n', '<Tab>', '<C-^>', { noremap = true, silent = true })
map('n', 'L', '<C-^>', { noremap = true, silent = true })

-- Paste without putting into clipboard
map("x", "<leader>p", [["_dP]])

-- Toggle autopairs
map("n", "<leader>ua", "<cmd>ToggleAutopairs<CR>", { desc = "Go to Definition" })

map("n", "<leader>uz", "<cmd>Lspsaga code_action<CR>", { desc = "LSP Code Action" })

-- Lspsaga mappings
map("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition" })
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP Code Action" })
map("n", "<leader>lca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP Code Action" })
map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "LSP Rename" })
map("n", "<leader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
map("n", "<leader>dN", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous Diagnostic" })
map("n", "<leader>da", "<cmd>Lspsaga show_workspace_diagnostics<CR>", { desc = "All Diagnostics" })
map("n", "<leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Buffer Diagaostics" })
map("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line Diagnostics" })
map("n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = "Cursor Diagnostics" })

-- Definition mappings
map("n", "<leader>h", "<cmd>Lspsaga finder tyd+ref+imp+def<CR>", { desc = "Get References" })
map("n", "<leader>j", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to Definition" })
map("n", "<leader>k", "<cmd>Lspsaga peek_definition<cr>", { desc = "Peek Definition" })
map('n', '<leader>l', '<cmd>Lspsaga hover_doc<CR>', { desc = "LSP Hover" })

map('n', 'dm', [[:lua DeleteMark()<CR>]], { desc = "[D]elete [M]ark [ ]"})

function DeleteMark()
  local mark = vim.fn.nr2char(vim.fn.getchar())
  vim.cmd('delmarks ' .. mark)
end

LazyVim.toggle.map("<leader>ug", {
  name = "Indention Guides",
  get = function()
    return require("ibl.config").get_config(0).enabled
  end,
  set = function(state)
    require("ibl").setup_buffer(0, { enabled = state })
  end,
})

-- Portal 
map("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
map("n", "<leader>i", "<cmd>Portal changelist backward<cr>")

-- Center when finding
map("n", "n", "nzzzv", {desc = "Next find and center"})
map("n", "N", "Nzzzv", {desc = "Prev find and center"})

-- Keep cursor in place
map("n", "J", "mzJ`z")

-- Easier registers
map('n', "'", "`", { noremap = true, silent = true })

-- vscode terminal 
map("n", "<localleader>t", "<cmd>ToggleTerm<CR>", { desc = "Floating Terminal" })
