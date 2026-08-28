return {
  "TheNoeTrevino/no-go.nvim",
  -- dir = "~/projects/no-go.nvim/",
  opts = {
    fold_imports = true,
    enabled = false,
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
  init = function()
    vim.keymap.set("n", "<leader>ngt", "<cmd>NoGoToggle<cr>", { desc = "NoGoToggle" })
  end,
}
