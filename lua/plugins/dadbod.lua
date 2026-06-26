return {
  "thenoetrevino/vim-dadbod-ui",
  -- branch = "feat/connection-groups",
  dir = "~/projects/vim-dadbod-ui",
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  dependencies = "vim-dadbod",
  keys = {
    { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    {
      "<leader>A",
      "<Plug>(DBUI_ExplainAnalyzeQuery)",
      mode = { "n", "x" },
      ft = "sql",
      remap = true,
      desc = "Explain Analyze",
    },
    { "<CR>", "<Plug>(DBUI_ExecuteQuery)", mode = "v", ft = "sql", remap = true, desc = "Execute SQL" },
    -- Normal mode only: the plugin doesn't define a visual <Plug> for this. Already the default, kept for the description.
    {
      "<leader>E",
      "<Plug>(DBUI_EditBindParameters)",
      mode = "n",
      ft = "sql",
      remap = true,
      desc = "Edit Parameters SQL",
    },
  },
  init = function()
    local data_path = vim.fn.stdpath("data")

    vim.g.db_ui_auto_execute_table_helpers = 1
    -- Recognize BOTH colon params (:name) and Postgres positional params ($1, $2, ...)
    -- as bind parameters. Vim regex: :\w\+\|\$\d\+ (default is just ':\w\+').
    vim.g.db_ui_bind_param_pattern = ":\\w\\+\\|\\$\\d\\+"
    vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_use_nvim_notify = true

    -- NOTE: The default behavior of auto-execution of queries on save is disabled
    -- this is useful when you have a big query that you don't want to run every time
    -- you save the file running those queries can crash neovim to run use the
    -- default keymap: <leader>S
    vim.g.db_ui_execute_on_save = false
  end,
}
