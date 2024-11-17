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

-- Respec indentation for java
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-------------------------------------------------------------------------------
--                           Markdown Section
-------------------------------------------------------------------------------

-- local function capitalize_sentences()
--   local line = vim.api.nvim_get_current_line()
--   line = line:gsub("[%.!?]%s*%l", function(match)
--     return match:upper()
--   end)
--   line = line:gsub("^%l", string.upper)
--   vim.api.nvim_set_current_line(line)
-- end
--
-- vim.api.nvim_create_autocmd("TextChangedI", {
--   pattern = "*.md",
--   callback = capitalize_sentences,
--   desc = "Auto-capitalize senteces in markdown files",
-- })
