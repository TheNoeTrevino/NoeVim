return {
  "nvim-neo-tree/neo-tree.nvim",
  event = "VeryLazy",
  cmd = "Neotree",
  opts = {
    popup_border_style = "rounded",
    sources = { "filesystem", "buffers", "git_status" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    filesystem = {
      bind_to_cwd = true, -- Change this to false to prevent binding to current working directory
      cwd_target = { -- Set the target for the working directory
        sidebar = "global", -- Set to "global" to bind to the root of the Git repository globally
        current = "global",
      },
      follow_current_file = { enabled = true },
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
        ["p"] = { "toggle_preview", config = { use_float = false } },
        ["f"] = "focus_preview",
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
