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
    vim.keymap.set("n", "<CR>", "<cmd>Lspsaga goto_definition<CR>")
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
    vim.api.nvim_set_hl(0, "String", { fg = "#89B482" })
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
