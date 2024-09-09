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
      { "<localleader>if", "<Plug>(neorg.telescope.insert_file_link)", desc = "[F]ile link", mode = "n" },
      { "<localleader>s", "<cmd>:Neorg toggle-concealer<CR>", desc = "[S]how Formatting", mode = "n" },
      { "<localleader>h", "<cmd>:Neorg toggle-concealer<CR>", desc = "[H]ide Formatting", mode = "n" },
      { "<leader>n", group = "[N]otes & [Notifs]   " },
      { "<localleader>l", group = "[L]ists  " },
      { "<localleader>c", group = "[C]ode Block  " },
      { "<localleader>i", group = "[I]nsert  " },
      { "<localleader>n", group = "[N]ew Note  " },
      { "<localleader>t", group = "[T]odo Marks  " },
    })
  end,
}
