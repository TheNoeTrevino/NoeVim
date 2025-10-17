return {
  "nvim-neo-tree/neo-tree.nvim",
  -- event = "UIEnter",
  cmd = "Neotree",
  opts = {
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
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer NeoTree (Root Dir)", remap = true },
      {
        "<leader>E",
        function()
          vim.cmd("Neotree position=left git_status selector=false toggle")
          vim.cmd("split")
          vim.cmd("Neotree position=left buffers selector=false toggle")
        end,
        desc = "Git Status + Buffers Split",
        remap = true,
      },
    }
  end,
}
