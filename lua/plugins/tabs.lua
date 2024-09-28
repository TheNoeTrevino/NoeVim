return {
  {
    "nanozuki/tabby.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      local theme = {
        -- fill = "TabLineFill",
        -- Also you can do this:
        fill = { fg = "#f2e9de", bg = "#000000", style = "italic" },
        head = "TabLine",
        -- current_tab = 'TabLineSel',
        current_tab = { fg = "#F8FBF6", bg = "#73695a" },
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      }

      require("tabby.tabline").set(function(line)
        return {
          {
            { "  ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            ---@diagnostic disable-next-line: missing-return-value
            return {
              line.sep("", hl, theme.fill),
              tab.is_current() and "" or "",
              -- tab.number(),
              tab.name(),
              -- tab.close_btn(''), -- show a close button
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          -- {
          --   line.sep("", theme.tail, theme.fill),
          --   { "  ", hl = theme.tail },
          -- },
          hl = theme.fill,
        }
      end)
    end,
  },
  {
    "LukasPietzschmann/telescope-tabs",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("telescope-tabs")
      require("telescope-tabs").setup({})
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
}
