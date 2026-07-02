-- dadbod-ui.nvim — full configuration reference.
-- Every option below maps to a key in the plugin's `config.lua` defaults.
-- Values shown are the plugin defaults unless a trailing comment says otherwise
-- (a few are set to your preferences, with the default noted).
local prefix = "<localleader>d"
return {
  -- "thenoetrevino/dadbod-ui.nvim",
  -- branch = "feat/connection-groups",
  dir = "~/projects/dadbod-ui.nvim/",
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  dependencies = "vim-dadbod",
  keys = {
    -- stylua: ignore start
    { prefix .. "d", function() require("dadbod-ui.api").toggle() end, desc = "Toggle DBUI" },
    { prefix .. "o", function() require("dadbod-ui.api").open() end, desc = "Open DBUI" },
    { prefix .. "f", function() require("dadbod-ui.api").find_buffer() end, desc = "DBUI find buffer" },
    { prefix .. "a", function() require("dadbod-ui.api").add_connection() end, desc = "DBUI add connection" },
    { prefix .. "i", function() require("dadbod-ui.api").last_query_info() end, desc = "DBUI last query info" },
    { prefix .. "e", function() require("dadbod-ui").execute_query() end, mode = "n", ft = "sql", desc = "Execute SQL (buffer)", },
    { prefix .. "s", function() require("dadbod-ui").switch_buffer() end, mode = "n", ft = "sql", desc = "Switch the current buffer's DB", },
    { "<CR>", function() require("dadbod-ui").execute_selection() end, mode = "x", ft = "sql", desc = "Execute SQL (selection)", },
    -- stylua: ignore end
  },
  config = function(_, opts)
    require("dadbod-ui").setup(opts)
  end,
  ---@type DadbodUI.Config
  opts = {
    save_location = "~/.local/share/db_ui",
    tmp_query_location = "",
    table_helpers = {},
    default_query = 'SELECT * from "{table}" LIMIT 200;',
    execute_on_save = false,
    auto_execute_table_helpers = false,
    env_variable_url = "DBUI_URL",
    env_variable_name = "DBUI_NAME",
    dotenv_variable_prefix = "DB_UI_",
    disable_progress_bar = false,
    notification_width = 40,
    winwidth = 40,
    win_position = "left",
    show_help = true,
    show_database_icon = true,
    use_nerd_fonts = true,
    ---@type table  icon overrides (see dadbod-ui.icons)
    icons = {},
    use_postgres_views = true,
    hide_schemas = {},
    bind_param_pattern = ":\\w\\+",
    drawer_sections = { "new_query", "buffers", "saved_queries", "schemas" },
    expand_groups = true,
    dbout_list_sort = "asc",
    force_echo_notifications = false,
    disable_info_notifications = false,
    use_nvim_notify = false,
    is_oracle_legacy = false,
    debug = false,
    disable_mappings = false,
    disable_mappings_dbui = false,
    disable_mappings_dbout = false,
    disable_mappings_sql = false,
    disable_mappings_javascript = false,
    ---@type DadbodUI.BufferNameGenerator|nil  custom buffer name generator
    buffer_name_generator = nil,
    ---@type DadbodUI.TableNameSorter|nil  custom table-list sorter
    table_name_sorter = nil,
  },
}
