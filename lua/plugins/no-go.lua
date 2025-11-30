return {
  opts = {
    fold_imports = true,
    enabled = true,
    reveal_on_cursor = true,
    keys = {
      down = "k",
      up = "l",
    },
    import_virtual_text = { -- e.g. ' 2  '
      prefix = " ",
      suffix = "   ",
    },
  },
  dir = "~/projects/no-go.nvim/",
  init = function()
    vim.keymap.set("n", "<leader>ngt", "<cmd>NoGoToggle<cr>", { desc = "NoGoToggle" })
  end,
}
