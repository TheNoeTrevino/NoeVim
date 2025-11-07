-- Dashboard with snacks.nvim
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      width = 60,
      row = nil, -- center
      col = nil, -- center
      pane_gap = 4,
      autokeys = "adfghjkl;zxcvnm,.",

      -- Custom preset configuration
      preset = {
        -- Custom header
        header = [[
    ███╗   ██╗ ██████╗ ███████╗██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔═══██╗██╔════╝██║   ██║██║████╗ ████║
    ██╔██╗ ██║██║   ██║█████╗  ██║   ██║██║██╔████╔██║
    ██║╚██╗██║██║   ██║██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║╚██████╔╝███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],

        -- Custom keymaps for the dashboard
      -- stylua: ignore start
        keys = {
          { icon = " ", key = "r", desc = "Reload Last Session", action = function() require("persistence").load() end },
          { icon = " ", key = "p", desc = "Projects", action =  function() Snacks.picker.projects() end },
          { icon = "󰆼 ", key = "d", desc = "Dadbod", action = function() vim.cmd("tabnew") vim.cmd("DBUIToggle") vim.cmd("tabonly") end, },
          { icon = " ", key = "s", desc = "Select Session", action = 'require("persistence").select()', },
          { icon = " ", key = "c", desc = "Config", action =  function() Snacks.picker.config() end },
          { icon = "󰊢 ", key = "G", desc = "Git Status", action = function() Snacks.lazygit() end },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
          { icon = "󰩈 ", key = "q", desc = "Quit", action = ":qa" },
        },
        -- stylua: ignore end
      },

      -- Dashboard sections
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
        },
        {
          pane = 2,
          icon = " ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 1,
        },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          cmd = "git status --short ",
          height = 10,
          padding = 1,
          ttl = 5 * 60,
        },
        { section = "startup" },
      },
    },
  },
}
