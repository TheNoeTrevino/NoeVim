-- dadbod-ui.nvim — full configuration reference.
-- Every option below maps to a key in the plugin's `config.lua` defaults.
-- Values shown are the plugin defaults unless a trailing comment says otherwise
-- (a few are set to your preferences, with the default noted).
local prefix = "<localleader>d"
return {
  -- "thenoetrevino/dadbod-ui.nvim",
  -- branch = "bugfix/splitting-when-opening-buffer-same-conn",
  dir = "~/projects/dadbod-ui.nvim/",
  lazy = false,
  dependencies = "tpope/vim-dadbod",
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
    {
      prefix .. "E",
      function()
        local variants = { "EXPLAIN ANALYZE", "EXPLAIN" }
        Snacks.picker.pick({
          title = "EXPLAIN",
          items = vim.tbl_map(function(v)
            return { text = v }
          end, variants),
          format = function(item)
            return { { item.text } }
          end,
          layout = { preview = false },
          confirm = function(picker, item)
            picker:close()
            if not item then
              return
            end
            require("dadbod-ui.api").execute_query(function(sql)
              return item.text .. "\n" .. sql
            end)
          end,
        })
      end,
      mode = "n",
      ft = "sql",
      desc = "EXPLAIN SQL (buffer)",
    },
    {
      prefix .. "r",
      function()
        local sql =
          table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() }), "\n")
        require("dadbod-ui.api").execute_pick(sql)
      end,
      mode = "x",
      ft = "sql",
      desc = "Run selection against a picked connection",
    },
  },
  config = function(_, opts)
    require("dadbod-ui").setup(opts)
  end,
  ---@type DadbodUI.Config
  opts = {
    save_location = "~/.local/share/db_ui",
    tmp_query_location = "",
    table_helpers = {},
    table_helpers_order = { "List", "Columns", "Indexes", "Primary Keys", "Foreign Keys", "References" },
    default_query = 'SELECT * from "{table}" LIMIT 200;',
    execute_on_save = false,
    auto_execute_table_helpers = false,
    page_size = 200,
    env_variable_url = "DBUI_URL",
    env_variable_name = "DBUI_NAME",
    dotenv_variable_prefix = "DB_UI_",
    disable_progress_bar = false,
    notification_width = 40,
    winwidth = 40,
    win_position = "left",
    result_layout = "horizontal",
    show_help = true,
    show_database_icon = true,
    use_nerd_fonts = true,
    ---@type table  icon overrides (see dadbod-ui.icons)
    icons = {},
    use_postgres_views = true,
    hide_schemas = {},
    bind_param_pattern = ":\\w\\+",
    drawer_sections = { "new_query", "buffers", "saved_queries", "schemas", "procedures" },
    expand_groups = true,
    dbout_list_sort = "asc",
    force_echo_notifications = false,
    disable_info_notifications = false,
    use_nvim_notify = false,
    -- Post-execute feedback: instead of dadbod's `DB: Running query...` /
    -- `finished in ...` command-line echoes (and our own "Executing query..."
    -- notification), show the completion + elapsed time inline. `result_buffer`
    -- pins a `winbar` summary to the top of the `.dbout` window; `query_buffer` puts
    -- ghost text trailing the line you executed from. When `enabled`, dadbod's two
    -- echoes are suppressed so the inline summary is the single source of feedback.
    query_time = {
      enabled = true,
      result_buffer = true,
      query_buffer = true,
      show_row_count = true,
    },
    -- Show the connection a query buffer targets in a right-aligned `winbar` at the
    -- top of the buffer's window, formatted `group/name` (or just `name` when the
    -- connection is ungrouped). Follows the buffer into new splits; the `.dbout`
    -- result buffers (which own their winbar) and the drawer are untouched.
    show_buffer_connection = true,
    -- Native CLI result export (see specs/native-export.md). `prefer_native` writes
    -- the CLI's own output when it can emit the target format directly (DECISION-001);
    -- turn it off to force the consistent Lua formatters for every adapter.
    -- `default_path` ('' => cwd) is the directory the export-path prompt defaults to;
    -- `coerce_numbers` opts the JSON/SQL formatters into emitting numeric/boolean
    -- literals (off by default since the CSV extract is untyped). The per-format
    -- sub-tables tune each formatter (see the format docs in dadbod-ui.export_formats).
    export = {
      prefer_native = true,
      default_path = "",
      coerce_numbers = false,
      csv = { delimiter = ",", header = true, quote = '"', null_string = "", line_feed_escape = "" },
      tsv = { line_feed_escape = "\\n" },
      json = { wrap_table_name = true, indent = "\t" },
    },
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
    -- User-configurable lifecycle hooks (see `DadbodUI.Hooks`). A table of optional
    -- functions fired around connect / execute / cancel. `on_connect(event)` is a
    -- transform: returning a string rewrites the connection url before connecting
    -- (e.g. swap a `$password` placeholder for a real secret). Its post/execute/
    -- cancel siblings are observers. A throwing hook is caught + notified, never
    -- aborting the underlying operation. Empty by default; set via `setup{}` opts.
    hooks = {},
    -- Keybindings, grouped by context. Each entry is `{ key, desc, mode? }`; set a
    -- key to 'none' to disable that action (it is then neither bound nor shown in
    -- the `?` help window). Overrides deep-merge, so `mappings.sidebar.delete.key`
    -- can be changed on its own. Display order + section titles are fixed (see
    -- `M.mapping_order` / `M.mapping_sections`). The single source of truth for
    -- both the live keymaps and the help window -- see `dadbod-ui.mappings`.
    mappings = {
      sidebar = {
        help = { key = "?", desc = "Toggle this help window" },
        toggle = { key = { "o", "<CR>" }, desc = "Open/Toggle selected item" },
        toggle_split = { key = "S", desc = "Open selected item in a split" },
        quit = { key = "q", desc = "Close the drawer" },
        add_connection = { key = "A", desc = "Add a connection" },
        delete = { key = "d", desc = "Delete selected item" },
        rename = { key = "r", desc = "Rename/edit buffer, connection, or saved query" },
        redraw = { key = "R", desc = "Redraw / refresh" },
        duplicate = { key = "D", desc = "Duplicate connection" },
        set_group = { key = "G", desc = "Add/remove connection to a group" },
        move_up = { key = "<C-Up>", desc = "Move connection up (crosses group boundaries)" },
        move_down = { key = "<C-Down>", desc = "Move connection down (crosses group boundaries)" },
        toggle_details = { key = "H", desc = "Toggle database details" },
        first_sibling = { key = "<C-k>", desc = "Go to first sibling" },
        last_sibling = { key = "<C-j>", desc = "Go to last sibling" },
        prev_sibling = { key = "K", desc = "Go to previous sibling" },
        next_sibling = { key = "J", desc = "Go to next sibling" },
        goto_parent = { key = "<C-p>", desc = "Go to parent node" },
      },
      query = {
        execute = { key = "<Leader>S", desc = "Execute query (whole buffer / visual selection)", mode = { "n", "v" } },
        edit_bind_params = { key = "<Leader>E", desc = "Edit bind parameters" },
        save_query = { key = "<Leader>W", desc = "Save the current query (tmp buffers)" },
        cancel = { key = "<Leader>C", desc = "Cancel the running query" },
      },
      results = {
        jump_foreign = { key = "<C-]>", desc = "Jump to the foreign key table" },
        cell_value = {
          key = "vic",
          desc = "Select the cell value under the cursor",
          binds = { { mode = "n", lhs = "vic" }, { mode = "o", lhs = "ic" } },
        },
        yank_header = { key = "yh", desc = "Yank the result header as CSV" },
        toggle_layout = { key = "<Leader>R", desc = "Toggle result layout (row / expanded)" },
        next_page = { key = "]", desc = "Next page of results" },
        prev_page = { key = "[", desc = "Previous page of results" },
        export = { key = "<Leader>X", desc = "Export result to a file" },
      },
    },
  },
}
