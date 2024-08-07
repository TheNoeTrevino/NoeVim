return {
  "nvimdev/lspsaga.nvim",
  config = function()
    require("lspsaga").setup({

      border_style = "round",
      saga_winblend = 0,
      move_in_saga = { prev = "<C-p>", next = "<C-n>" },
      code_action_keys = {
        quit = "<Esc>",
        exec = "<CR>",
      },
      rename_action_quit = "<C-c>",
      definition_preview_icon = "🔍  ",
      finder_action_keys = {
        open = "o",
        vsplit = "s",
        split = "i",
        tabe = "t",
        quit = "<Esc>",
      },
      hover = {
        border_style = "round",
        border = "single",
        max_width = 0.9,
        max_height = 0.8,
        open_link = "<leader>ol",
        open_cmd = "!explorer",
      },
      lightbulb = {
        enable = false, -- Disable the lightbulb
      },
      rename = {
        in_select = true,
        auto_save = false,
        project_max_width = 0.5,
        project_max_height = 0.5,
        keys = {
          quit = "<Esc>",
          exec = "<CR>",
          select = "x",
        },
      },
    })
  end,
}
