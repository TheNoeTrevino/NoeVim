return {
  "nvim-neo-tree/neo-tree.nvim",
  -- event = "UIEnter",
  cmd = "Neotree",
  opts = {
    popup_border_style = "single",
    sources = { "filesystem", "buffers", "git_status" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    filesystem = {
      bind_to_cwd = false,
      cwd_target = {
        sidebar = "global",
        current = "global",
      },
      follow_current_file = { enabled = false },
      use_libuv_file_watcher = true,
      --avante
      commands = {
        avante_add_files = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local relative_path = require("avante.utils").relative_path(filepath)

          local sidebar = require("avante").get()

          local open = sidebar:is_open()
          -- ensure avante sidebar is open
          if not open then
            require("avante.api").ask()
            sidebar = require("avante").get()
          end

          sidebar.file_selector:add_selected_file(relative_path)

          -- remove neo tree buffer
          if not open then
            sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
          end
        end,
      },
    },
    window = {
      popup = {
        title = function()
          local cwd = vim.fn.getcwd()
          local path = vim.fn.expand("%:p:h")
          local file = vim.fn.expand("%:t")
          local rel_path = path:gsub(cwd, ""):gsub("^/", "")
          local base = rel_path ~= "" and rel_path or vim.fn.fnamemodify(cwd, ":t")
          return file ~= "" and base .. "/" .. file or base
        end,
      },
      position = "float",
      mappings = {
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["l"] = "none",
        ["h"] = "none",
        [";"] = "open",
        ["j"] = "close_node",
        ["<space>"] = "none",
        ["f"] = "focus_preview",
        ["<C-u>"] = { "scroll_preview", config = { direction = 10 } },
        ["<C-d>"] = { "scroll_preview", config = { direction = -10 } },
        ["/"] = "none",
        ["oa"] = "avante_add_files",
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      git_status = {
        symbols = {
          unstaged = "󰄱",
          staged = "󰱒",
        },
      },
    },
  },
  keys = function()
    return {
      { "<leader>e", "<cmd>Neotree reveal_force_cwd toggle<cr>", desc = "Explorer NeoTree (Root Dir)", remap = true },
      {
        "<leader>ne",
        "<cmd>Neotree reveal toggle dir=~/notes/<cr>",
        desc = "Notes explorer",
        remap = true,
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    }
  end,
}
