return {
  "petertriho/nvim-scrollbar",
  event = "VeryLazy",
  opts = {
    excluded_filetypes = {
      -- defaults (must be repeated: opts are merged by list index)
      "blink-cmp-menu",
      "dropbar_menu",
      "dropbar_menu_fzf",
      "DressingInput",
      "dbui",
      "cmp_docs",
      "cmp_menu",
      "noice",
      "prompt",
      "TelescopePrompt",
      -- extras
      "OverseerList",
      "snacks_input",
      "snacks_picker_input",
      "snacks_picker_list",
      "snacks_notif",
      "snacks_dashboard",
    },
  },
}
