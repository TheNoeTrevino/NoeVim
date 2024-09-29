-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<localleader>t", "<cmd>:ToggleTerm<CR>", opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

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
