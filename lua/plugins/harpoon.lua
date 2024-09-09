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
    local harpoon = require("harpoon")
    local keys = {
      {
        "H",
        function()
          harpoon:list():add()
          vim.notify(" Harpooned 󱡀 ", vim.log.levels.INFO, { title = "Harpoon" })
        end,
        desc = "󱡀 Harpoon File",
      },
      {
        "h",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "<leader>j",
        function()
          harpoon:list():prev()
        end,
        desc = "Harpoon Previous",
      },
      {
        "<leader>;",
        function()
          harpoon:list():next()
        end,
        desc = "Harpoon Next",
      },
    }
    for i = 1, 5 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end
    return keys
  end,
}
