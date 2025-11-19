local get_config_vert = function()
  return {
    layout = {
      cycle = true,
      --- Use the default layout or vertical if the window is too narrow
      preset = "vertical",
    },
  }
end

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
          { icon = " ", key = "p", desc = "Projects", action =  function() Snacks.picker.projects(get_config_vert()) end },
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
        -- function()
        --   local in_git = Snacks.git.get_root() ~= nil
        --   local cmds = {
        --     {
        --       title = "Notifications",
        --       cmd = "gh notify -s -a -n5",
        --       action = function()
        --         vim.ui.open("https://github.com/notifications")
        --       end,
        --       key = "n",
        --       icon = " ",
        --       height = 5,
        --       enabled = true,
        --     },
        --     {
        --       title = "Open Issues",
        --       cmd = "gh issue list -L 3",
        --       key = "i",
        --       action = function()
        --         vim.fn.jobstart("gh issue list --web", { detach = true })
        --       end,
        --       icon = " ",
        --       height = 7,
        --     },
        --     {
        --       icon = " ",
        --       title = "Open PRs",
        --       cmd = "gh pr list -L 3",
        --       key = "P",
        --       action = function()
        --         vim.fn.jobstart("gh pr list --web", { detach = true })
        --       end,
        --       height = 7,
        --     },
        --     {
        --       icon = " ",
        --       title = "Git Status",
        --       cmd = "git --no-pager diff --stat -B -M -C",
        --       height = 10,
        --     },
        --   }
        --   return vim.tbl_map(function(cmd)
        --     return vim.tbl_extend("force", {
        --       pane = 2,
        --       section = "terminal",
        --       enabled = in_git,
        --       padding = 1,
        --       ttl = 5 * 60,
        --       indent = 3,
        --     }, cmd)
        --   end, cmds)
        -- end,
        { section = "startup" },
        -- {
        --   pane = 2,
        --   icon = " ",
        --   title = "Git Status",
        --   section = "terminal",
        --   cmd = "git status --porcelain | head -10",
        --   height = 10,
        --   padding = 1,
        --   ttl = 5 * 60,
        -- },
        -- { section = "startup" },
      },
    },
  },
}
