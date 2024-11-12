return {
  "ThePrimeagen/refactoring.nvim",
  event = "VeryLazy",
  config = function()
    require("refactoring").setup({})
    local map = vim.keymap.set

    map("x", "<leader>rf", ":Refactor extract ", { desc = "Extract selection to a new function" })
    map("x", "<leader>rF", ":Refactor extract_to_file ", { desc = "Extract selection to a new file" })

    map("x", "<leader>rv", ":Refactor extract_var ", { desc = "Extract selection to a new variable" })

    map({ "n", "x" }, "<leader>rV", ":Refactor inline_var", { desc = "Inline variable" })

    map("n", "<leader>rI", ":Refactor inline_func", { desc = "Inline function" })

    map("n", "<leader>rb", ":Refactor extract_block", { desc = "Extract block of code to a new function" })
    map("n", "<leader>rB", ":Refactor extract_block_to_file", { desc = "Extract block of code to a new file" })
  end,
}
