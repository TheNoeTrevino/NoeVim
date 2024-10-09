return {
  "nvim-neo-tree/neo-tree.nvim",
  -- event = "UIEnter",
  cmd = "Neotree",
  opts = {
    popup_border_style = "rounded",
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
    },
    window = {
      position = "float",
      mappings = {
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["l"] = "none",
        ["h"] = "none",
        [";"] = "open",
        ["j"] = "close_node",
        ["<space>"] = "none",
        ["p"] = { "toggle_preview", config = { use_float = true } },
        ["f"] = "focus_preview",
        ["<C-u>"] = { "scroll_preview", config = { direction = 10 } },
        ["<C-d>"] = { "scroll_preview", config = { direction = -10 } },
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
