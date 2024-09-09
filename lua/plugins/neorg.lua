return {
  "nvim-neorg/neorg",
  event = "VeryLazy",
  version = "*",
  config = function()
    require("neorg").setup({
      dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-neorg/neorg-telescope" } },
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              school = "~/.neorg/school",
              study = "~/.neorg/study",
              projects = "~/.neorg/projects",
            },
            default_workspace = "study",
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.integrations.telescope"] = {
          config = {
            insert_file_link = {
              show_title_preview = true,
            },
          },
        },
      },
    })
    vim.wo.foldlevel = 99
    vim.wo.conceallevel = 2

    local wk = require("which-key")
    wk.add({
      { "<leader>sn", "<Plug>(neorg.telescope.find_norg_files)", desc = "Search Notes", mode = "n" },
      { "<localleader>if", "<Plug>(neorg.telescope.insert_file_link)", desc = "File link", mode = "n" },
      { "<localleader>s", "<cmd>:Neorg toggle-concealer<CR>", desc = "Show Formatting", mode = "n" },
      { "<localleader>h", "<cmd>:Neorg toggle-concealer<CR>", desc = "Hide Formatting", mode = "n" },
      { "<leader>n", group = "Notes & Notifs   " },
      { "<localleader>l", group = "Lists  " },
      { "<localleader>c", group = "Code Block  " },
      { "<localleader>i", group = "Insert  " },
      { "<localleader>n", group = "New Note  " },
      { "<localleader>t", group = "Todo Marks  " },
    })
  end,
}
