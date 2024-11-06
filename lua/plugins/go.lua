return {
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    -- branch = "develop", -- if you want develop branch
    -- keep in mind, it might break everything
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
    },
    -- (optional) will update plugin's deps on every update
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    ---@type gopher.Config
    opts = {},

    config = function()
      local map = LazyVim.safe_keymap_set
      map("n", "<leader>glj", "<cmd>GoTagAdd json<cr>", { desc = "Add JSON Tag" })
      map("n", "<leader>glJ", "<cmd>GoTagRm json<cr>", { desc = "Rm JSON Tag" })
      map("n", "<leader>glta", "<cmd>GoTestAdd<cr>", { desc = "Add Test for Function" })
      map("n", "<leader>gltA", "<cmd>GoTestsAll<cr>", { desc = "Generate All Tests" })
      map("n", "<leader>glg", ":GoGet", { desc = "Get Package" })
      map("n", "<leader>glT", "<cmd>GoMod tidy<cr>", { desc = "Go Tidy" })
      map("n", "<leader>gls", "<cmd>GoWork sync<cr>", { desc = "Go Sync" })
      map("n", "<leader>gle", "<cmd>GoIfErr<cr>", { desc = "Handle Err" })
    end,
  },
}
