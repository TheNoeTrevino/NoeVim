return {
  "nvimdev/lspsaga.nvim",
  event = "VeryLazy",
  config = function()
    require("lspsaga").setup({
      definition = {
        keys = {
          edit = "<C-c>o",
          vsplit = "v",
          split = "s",
          tabe = "<C-c>t",
          quit = { "q", "<ESC>" },
          close = "<C-c>k",
        },
      },
      outline = {
        win_position = "left",
        win_width = 40,
        auto_preview = true,
        detail = true,
        auto_close = true,
        close_after_jump = false,
        layout = "float",
        max_height = 0.7,
        keys = {
          jump = "<CR>",
          quit = { "q", "<ESC>" },
          close = "<ESC>",
        },
      },
      finder = {
        max_height = 0.8,
        right_width = 0.5,
        left_width = 0.5,
        keys = {
          vsplit = "v",
          split = "i",
          shuttle = "w", --
          toggle_or_open = "<CR>", --toggle expand or open
          tabe = "t",
          tabnew = "r",
          quit = { "q", "<ESC>" },
          -- close = "<ESC>",
        },
      },
      symbol_in_winbar = {
        enable = true, -- Disable the breadcrumbs
      },
      border_style = "round",
      saga_winblend = 0,
      move_in_saga = { prev = "<C-p>", next = "<C-n>" },
      code_action = {
        keys = {
          quit = { "q", "<ESC>" },
        },
      },
      rename_action_quit = "<C-c>",
      definition_preview_icon = "🔍  ",
      finder_action_keys = {
        open = "o",
        vsplit = "s",
        split = "i",
        tabe = "t",
        quit = { "q", "<ESC>" },
      },
      hover = {
        border_style = "round",
        border = "single",
        max_width = 0.9,
        max_height = 0.8,
        open_link = "<leader>ol",
        open_cmd = "!explorer",
        keys = {
          quit = { "q", "<ESC>" },
        },
      },
      diagnostics = {
        keys = {
          quit = { "q", "<ESC>" },
        },
      },
      lightbulb = {
        enable = false, -- Disable the lightbulb
        virtual_text = false,
      },
      ui = {
        code_action = "󱚠",
      },
      rename = {
        in_select = true,
        auto_save = false,
        project_max_width = 0.5,
        project_max_height = 0.5,
        keys = {
          quit = { "q", "<ESC>" },
          exec = "<CR>",
          select = "x",
        },
      },
    })
  end,
}
