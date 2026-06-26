local get_config_vert = function()
  return {
    layout = {
      cycle = true,
      --- Use the default layout or vertical if the window is too narrow
      preset = "vertical",
    },
  }
end

local function browse_saved_requests()
  local path = vim.fn.expand("~/.local/share/kulala")
  vim.fn.mkdir(path, "p")

  vim.cmd("tabnew")
  vim.cmd("TabRename kulala")
  -- Scope this tab's cwd to the store so git and cwd-relative tools work here
  -- without touching the cwd of any other tab.
  vim.cmd.tcd(vim.fn.fnameescape(path))
  require("neo-tree.command").execute({
    action = "show",
    source = "filesystem",
    position = "left",
    dir = path,
    reveal_force_cwd = true,
  })
end

local function open_dadbod()
  vim.cmd("tabnew")
  vim.cmd("TabRename dadbod")
  vim.cmd("DBUIToggle")
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
        -- Backs Snacks.dashboard.pick(...) via our util picker.
        pick = function(cmd, opts)
          return require("util").pick(cmd, opts)()
        end,

        -- Custom header
        header = [[
                                          ███                               
             ████ ██████              █████    █  ██                   
            ███████████               █████  ███                        
            █████████ ██████ ████████████████ ██ ██████████    
           █████████ ██  ██ ██    ██████████ ████ ██████████████    
          █████████ ███    ███ █████ ████████  ████ ████████████    
        ███████████ ███  ███  ██    ██████   ████ ████ ████ ████    
       ██████  ███   ████████    █████ ████    ████ ████ ████ ████   
        ]],

        -- Custom keymaps for the dashboard
      -- stylua: ignore start
        keys = {
          { icon = " ", key = "r", desc = "Reload Last Session", action = function() require("persistence").load() end },
          { icon = " ", key = "p", desc = "Projects", action =  function() Snacks.picker.projects(get_config_vert()) end },
          { icon = "󰆼 ", key = "d", desc = "Dadbod", action = function() open_dadbod() end, },
          { icon = "󱣻 ", key = "R", desc = "Kulala", action = function() browse_saved_requests() end, },
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
        -- {
        --   pane = 2,
        --   section = "terminal",
        --   cmd = "colorscript -e square",
        --   height = 5,
        --   padding = 1,
        -- },
        { section = "keys", gap = 1, padding = 1 },
        -- { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        -- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        -- {
        --   pane = 2,
        --   icon = " ",
        --   title = "Git Status",
        --   section = "terminal",
        --   enabled = function()
        --     return Snacks.git.get_root() ~= nil
        --   end,
        --   cmd = "git status --short --branch --renames",
        --   height = 5,
        --   padding = 1,
        --   ttl = 5 * 60,
        --   indent = 3,
        -- },
        { section = "startup" },
      },
    },
  },
}
