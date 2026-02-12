return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  cond = function()
    return vim.loop.os_uname().sysname ~= "Windows_NT"
  end,
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
        ["<esc>"] = function(state)
          vim.cmd("Neotree toggle")
        end,
      },
    },
  },
  keys = function()
    return {
      { "<leader>e", "<cmd>Neotree reveal_force_cwd toggle<cr>", desc = "Explorer NeoTree (Root Dir)", remap = true },
    }
  end,
}
