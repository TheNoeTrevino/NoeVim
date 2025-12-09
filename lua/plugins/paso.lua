return {
  "TheNoeTrevino/paso.nvim",
  -- dir = "~/projects/paso.nvim/",
  init = function()
    vim.keymap.set("n", "<leader>pt", "<cmd>lua require('paso').open()<cr>", { desc = "Paso Toggle" })
  end,
}
