return {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  branch = "harpoon2",
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local toggle_opts = {
      border = "single",
      title_pos = "center",
      ui_width_ratio = 0.66666666666666667,
    }
    local harpoon = require("harpoon")
    local keys = {
      {
        "H",
        function()
          harpoon:list():add()
          vim.notify("This file has been added to the Harpoon list", vim.log.levels.INFO, { title = "Harpooned 󱡀 " })
        end,
        desc = "󱡀 Harpoon File",
      },
      {
        "<leader>h",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts)
        end,
        desc = "Harpoon Menu",
      },
    }
    -- Highlight the current file if exists
    local harpoon_extensions = require("harpoon.extensions")
    harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
    harpoon:extend(harpoon_extensions.builtins.navigate_with_number())
    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "v", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "s", function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "t", function()
          harpoon.ui:select_menu_item({ tabedit = true })
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", "o", function()
          harpoon.ui:select_menu_item()
        end, { buffer = cx.bufnr })

        vim.keymap.set("n", ";", function()
          harpoon.ui:select_menu_item()
        end, { buffer = cx.bufnr })

        for i = 1, 9 do
          vim.keymap.set("n", "" .. i, function()
            harpoon:list():select(i)
          end)
        end
      end,
    })
    for i = 1, 9 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          harpoon:list():select(i)
        end,
        desc = "Harpoon " .. i,
      })
    end
    return keys
  end,
}
