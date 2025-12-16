return {
  "TheNoeTrevino/paso.nvim",
  -- dir = "~/projects/paso.nvim/",
  init = function()
    vim.keymap.set("n", "<leader>pt", "<cmd>lua require('paso').open({ win = { height = 0, width = 0, }})<cr>",
      { desc = "Paso Toggle" })
  end,
}
