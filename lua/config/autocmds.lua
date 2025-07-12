-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<localleader>t", "<cmd>:ToggleTerm<CR>", opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- save buffers in markdown when leaving then
vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "set awa" })

-- Make * double for markdown files. For some reason in markdown * is italic?
-- and so is _ ? weird
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    require("nvim-surround").buffer_setup({
      surrounds = {
        ["*"] = {
          add = function()
            return { { "**" }, { "**" } }
          end,
        },
      },
    })
  end,
})

local function setup_highlight_for_gruvbox()
  if vim.g.colors_name == "gruvbox" then
    vim.api.nvim_set_hl(0, "String", { fg = "#89b55b" })
    vim.api.nvim_set_hl(0, "Search", { fg = "#2E3436", bg = "#A8B665" })
    vim.api.nvim_set_hl(0, "CurSearch", { fg = "#FFFFFF", bg = "#EA6962" })
    -- vim.api.nvim_set_hl(0, "Identifier", { fg = "#89B482" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "gruvbox",
  callback = function()
    setup_highlight_for_gruvbox()
  end,
})

setup_highlight_for_gruvbox()

local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "moonfly",
  callback = function()
    vim.api.nvim_set_hl(0, "Boolean", { fg = "#849e5d", bold = false })
  end,
  group = custom_highlight,
})

-- Copilot is now markdown
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "copilot-*",
  callback = function()
    vim.opt_local.relativenumber = true
    vim.opt_local.number = true
    local ft = vim.bo.filetype
    if ft == "copilot-chat" then
      vim.bo.filetype = "markdown"
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "GitConflictDetected",
  callback = function()
    vim.notify("Conflict detected in: " .. vim.fn.expand("%:t") .. " ")

    -- Schedule Telescope to run after the current event loop
    vim.schedule(function()
      vim.cmd("GitConflictListQf")
      vim.cmd("cclose")
    end)
  end,
})

local map = LazyVim.safe_keymap_set

vim.api.nvim_create_user_command("NormMap", function()
  vim.keymap.del("n", "h")
  vim.keymap.del("n", "j")
  vim.keymap.del("n", "l")
  vim.keymap.del("n", ";")

  map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
  map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

  -- Remap j; for navigation/o-pending
  map({ "n", "x", "o" }, "h", "<Left>", { desc = "Right", silent = true })
  map("o", "j", "<Down>", { desc = "Down", silent = true })
  map("o", "k", "<Up>", { desc = "Up", silent = true })
  map({ "n", "x", "o" }, "l", "<Right>", { desc = "Left", silent = true })

  -- Move Lines
  map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
  map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
  map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
  map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
  map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
  map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })

  -- Terminal Mappings
  map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
  map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
  map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
  map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

  map("n", "<C-h>", ":KittyNavigateLeft<CR>", { noremap = true, silent = true })
  map("n", "<C-j>", ":KittyNavigateDown<CR>", { noremap = true, silent = true })
  map("n", "<C-k>", ":KittyNavigateUp<CR>", { noremap = true, silent = true })
  map("n", "<C-l>", ":KittyNavigateRight<CR>", { noremap = true, silent = true })
end, {})

vim.api.nvim_create_user_command("NoeMap", function()
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

  map("n", "<C-j>", ":KittyNavigateLeft<CR>", { noremap = true, silent = true })
  map("n", "<C-k>", ":KittyNavigateDown<CR>", { noremap = true, silent = true })
  map("n", "<C-l>", ":KittyNavigateUp<CR>", { noremap = true, silent = true })
  map("n", "<C-;>", ":KittyNavigateRight<CR>", { noremap = true, silent = true })
end, {})

vim.api.nvim_create_user_command("ToggleGutter", function()
  if vim.wo.number or vim.wo.relativenumber or vim.wo.signcolumn ~= "no" or vim.wo.foldcolumn ~= "0" then
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.foldcolumn = "0"
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.wo.signcolumn = "yes"
    vim.wo.foldcolumn = "1"
  end
end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    vim.keymap.set("v", "<CR>", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute SQL" })
    vim.keymap.set(
      "v",
      "<leader>E",
      "<Plug>(DBUI_EditBindParameters)|",
      { buffer = true, desc = "Edit Parameters SQL" }
    )

    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.smartindent = true
    vim.bo.cinoptions = "j1,J1,(0,w1,W1"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.cindent = true
    vim.bo.cinoptions = "j1,J1,(0,w1,W1"
  end,
})
