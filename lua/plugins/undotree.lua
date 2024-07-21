return {
    "mbbill/undotree",
    config = function()
        vim.g.undotree_DiffpanelHeight = 20
        vim.g.undotree_SplitWidth = 40
        vim.g.undotree_DiffAutoOpen = 1
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_TreeNodeShape = '*'
        vim.g.undotree_TreeVertShape = '|'
        vim.g.undotree_TreeSplitShape = '/'
        vim.g.undotree_TreeReturnShape = '\\'
        vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Toggle Undotree" })
    end,
}
