return {
  "nvim-neo-tree/neo-tree.nvim",
  -- event = "UIEnter",
  cmd = "Neotree",
  opts = {
    add_blank_line_at_top = true,
    popup_border_style = "single",
    source_selector = {
      winbar = true,
      content_layout = "center", -- only with `tabs_layout` = "equal", "focus"
    },
    window = {
      popup = {
        size = {
          height = "85%",
          width = "50%",
        },
        title = "NoeVim",
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
      },
    },
  },
  keys = function()
    return {
      { "<leader>e", "<cmd>Neotree reveal_force_cwd toggle<cr>", desc = "Explorer NeoTree (Root Dir)", remap = true },
    }
  end,
}
