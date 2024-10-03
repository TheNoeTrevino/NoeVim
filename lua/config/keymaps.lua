-- Remove LazyVim Mappings
vim.keymap.del("n", "<leader>`")
vim.keymap.del("n", "<leader>|")
vim.keymap.del("n", "<leader>-")
vim.keymap.del("n", "<leader>L")
vim.keymap.del("n", "<leader>l")
vim.keymap.del("n", "<leader>K")
vim.keymap.del("n", "<leader>,")
vim.keymap.del("n", "<leader>snt")
vim.keymap.del("n", "<leader>st")
vim.keymap.del("n", "<leader><Tab>[")
vim.keymap.del("n", "<leader><Tab>]")
vim.keymap.del("n", "<leader><Tab>d")
vim.keymap.del("n", "<leader><Tab>l")
vim.keymap.del("n", "<leader><Tab>o")
vim.keymap.del("n", "<leader><Tab>f")
vim.keymap.del("n", "<leader><Tab><tab>")

local map = LazyVim.safe_keymap_set
-- WEIRD MAPPINGS -- edit/remove this block to use hjkl for navigation
-- better up/down
map({ "n", "x" }, "k", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "l", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Remap j; for navigation
map({ "n", "x" }, "j", "h", { desc = "Right", silent = true })
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

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

--Dial
map("n", "+", "<C-A>", { desc = "Quickfix List" })
map("n", "-", "<C-X>", { desc = "Quickfix List" })

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
map("n", "<leader>ut", "<cmd>UndotreeToggle<cr>", { desc = "Undotree" })
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

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-j>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-k>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-l>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-;>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Tabs
map("n", "<tab>p", "<cmd>tabprevious<cr>", { desc = "Tab Previous" })
map("n", "<tab>n", "<cmd>tabnext<cr>", { desc = "Tab Next" })
map("n", "<tab>r", ":Tabby rename_tab ", { desc = "Tab Rename" })
map("n", "<tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<tab>c", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<tab>1", "1gt", { desc = "Tab 1" })
map("n", "<tab>2", "2gt", { desc = "Tab 2" })
map("n", "<tab>3", "3gt", { desc = "Tab 3" })
map("n", "<tab>4", "4gt", { desc = "Tab 4" })
map("n", "<leader>t", "<cmd>Telescope telescope-tabs list_tabs<CR><esc>", { desc = " Tab Search" })

-- Windows
LazyVim.toggle.map("<leader>mm", LazyVim.toggle.maximize)

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "which_key_ignore" })

-- Disable the default mappings from vim-kitty-navigator
vim.g.kitty_navigator_no_mappings = 1

-- Navigate Between Neovim and Kitty splits
map('n', '<C-j>', ':KittyNavigateLeft<CR>', { noremap = true, silent = true})
map('n', '<C-k>', ':KittyNavigateDown<CR>', { noremap = true, silent = true})
map('n', '<C-l>', ':KittyNavigateUp<CR>', { noremap = true, silent = true})
map('n', '<C-;>', ':KittyNavigateRight<CR>', { noremap = true, silent = true})

-- Resize with arrows
map("n", "<Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
map("n", "<Left>", "<cmd>vertical resize -2<cr>", { desc = "Increase Window Width" })

-- Better alternate buffer
map('n', 'L', '<C-^>', { noremap = true, silent = true })

-- Paste without putting into clipboard
map("x", "<leader>p", [["_dP]])

-- Toggle autopairs
map("n", "<leader>ua", "<cmd>ToggleAutopairs<CR>", { desc = "Go to Definition" })

-- Lspsaga mappings
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP Code Action" })

-- Diagnostics
map("n", "<leader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
map("n", "<leader>dN", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous Diagnostic" })
map("n", "<leader>da", "<cmd>Lspsaga show_workspace_diagnostics<CR>", { desc = "All Diagnostics" })
map("n", "<leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Buffer Diagaostics" })
map("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line Diagnostics" })
map("n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = "Cursor Diagnostics" })

map("n", "<leader>dta", "<cmd>Trouble diagnostics toggle<CR>", { desc = "All Diagnostics" })
map("n", "<leader>dtb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {desc = "Buffer Diagnostics"})

-- Definition mappings
map("n", "<leader>h", "<cmd>Lspsaga finder tyd+ref+def<CR>", { desc = "Get References" })
map("n", "<leader>j", "<cmd>Lspsaga goto_definition<CR>", { desc = "Jump to Definition" })
map("n", "<leader>k", "<cmd>Lspsaga peek_definition<cr>", { desc = "Peek Definition" })
map('n', '<leader>l', '<cmd>Lspsaga outline<cr>', { desc = "Outline" })


map('n', 'dm', [[:lua DeleteMark()<CR>]], { desc = "Delete Mark x"})

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

-- Jump and change list
map("n", "<leader>o", "<cmd>Portal jumplist backward<cr>",{ desc = "Jumplist Backward" })
map("n", "<leader>i", "<cmd>Portal jumplist forward<cr>",{ desc = "Jumplist Forward" })

map("n", "<leader>;", "<cmd>Portal changelist backward<cr>",{ desc = "Changelist Backward" })
map("n", "<leader>'", "<cmd>Portal changelist forward<cr>",{ desc = "Changelist Forward" })

-- HACK: Terminal maps <C-i> to tab, so i mapped = to <c-i> in kitty, then this here
map("n", "=", "<C-i>",{ desc = "Changelist Forwards" })

-- Center when finding
map("n", "n", "nzzzv", {desc = "Next find and center"})
map("n", "N", "Nzzzv", {desc = "Prev find and center"})

-- Keep cursor in place
map("n", "J", "mzJ`z")

-- Easier marks
map('n', "'", "<cmd>WhichKey `<cr>", { noremap = true, silent = true })

-- VsCode terminal 
map("n", "<localleader>t", "<cmd>ToggleTerm<CR>", { desc = "Terminal" })
map('x', '<localleader>sl', '<cmd>ToggleTermSendVisualLines<CR>', { desc = "Send Visual Lines" })

-- Toggle Transparency
map("n", "<leader>0", "<cmd>TransparentToggle<CR>", { desc = "Transparency" })

-- Toggle Transparency
map("n", "<leader>ue", "<cmd>SunglassesEnableToggle<CR><cmd>SunglassesRefresh<CR>", { desc = "Toggle Tine" })

-------------------------------------------------------------------------------
--                           Markdown section
-------------------------------------------------------------------------------


-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
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
vim.keymap.set("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
end, { desc = "Unfold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
end, { desc = "Fold all headings level 1 or above" })

-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
end, { desc = "Fold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
end, { desc = "Fold all headings level 3 or above" })

-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
end, { desc = "Fold all headings level 4 or above" })

-------------------------------------------------------------------------------
--                          End Markdown section
-------------------------------------------------------------------------------
