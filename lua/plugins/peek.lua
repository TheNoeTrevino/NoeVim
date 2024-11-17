---@diagnostic disable: missing-fields
return {
  "dnlhc/glance.nvim",
  config = function()
    -- Lua configuration
    local glance = require("glance")
    local actions = glance.actions

    glance.setup({
      height = 18, -- Height of the window
      zindex = 45,
      detached = false,
      preview_win_opts = { -- Configure preview window options
        cursorline = true,
        number = true,
        wrap = true,
      },
      border = {
        enable = true, -- Show window borders. Only horizontal borders allowed
        top_char = "―",
        bottom_char = "―",
      },
      list = {
        position = "right", -- Position of the list window 'left'|'right'
        width = 0, -- 33% width relative to the active window, min 0.1, max 0.5
      },
      theme = { -- This feature might not work properly in nvim-0.7.2
        enable = true, -- Will generate colors for the plugin based on your current colorscheme
        mode = "darken", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
      },
      mappings = {
        list = {
          ["k"] = actions.next, -- Bring the cursor to the next item in the list
          ["l"] = actions.previous, -- Bring the cursor to the previous item in the list
          ["<Down>"] = actions.next,
          ["<Up>"] = actions.previous,
          ["<Tab>"] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
          ["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
          ["<C-u>"] = actions.preview_scroll_win(5),
          ["<C-d>"] = actions.preview_scroll_win(-5),
          ["v"] = actions.jump_vsplit,
          ["s"] = actions.jump_split,
          ["t"] = actions.jump_tab,
          ["<CR>"] = actions.jump,
          ["o"] = actions.jump,
          [";"] = actions.open_fold,
          ["h"] = actions.close_fold,
          ["j"] = actions.enter_win("preview"), -- Focus preview window
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["gk"] = actions.close,
          ["<Esc>"] = actions.close,
          ["<C-q>"] = actions.quickfix,
        },
        preview = {
          ["<Tab>"] = actions.next_location,
          ["<S-Tab>"] = actions.previous_location,
          ["<leader>l"] = actions.enter_win("list"), -- Focus list window
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["gk"] = actions.close,
          ["<Esc>"] = actions.close,
          ["v"] = actions.jump_vsplit,
          ["s"] = actions.jump_split,
        },
      },
      winbar = {
        enable = false, -- Available strating from nvim-0.8+
      },
    })
  end,
}
