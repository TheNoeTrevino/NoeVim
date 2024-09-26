return {
  "nvimdev/dashboard-nvim",
  priority = 1000,
  opts = function()
    local logo = [[
                                                                                
                                                                                
                                                                                
                                                                                
                                          ███                               
             ████ ██████              █████    █  ██                   
            ███████████               █████  ███                        
            █████████ ██████ ████████████████ ██ ██████████    
           █████████ ██  ██ ██    ██████████ ████ ██████████████    
          █████████ ███    ███ █████ ████████  ████ ████████████    
        ███████████ ███  ███  ██    ██████   ████ ████ ████ ████    
       ██████  ███   ████████    █████ ████    ████ ████ ████ ████   
                                                                                
                                                                                
  ]]

    logo = string.rep("\n", 7) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        center = {
          {
            action = 'lua require("persistence").load()',
            desc = " Reload Last Session",
            icon = " ",
            key = "r",
          },
          {
            action = function()
              vim.cmd(" Leet")
            end,
            desc = " Leetcode",
            icon = " ",
            key = "p",
          },
          { action = "lua LazyVim.pick()()", desc = " Find File", icon = "󰥨 ", key = "f" },
          {
            action = 'lua LazyVim.pick("oldfiles")()',
            desc = " Recent Files",
            icon = " ",
            key = "o",
          },
          {
            action = function()
              vim.cmd("Telescope live_grep")
            end,
            desc = " Live Grep",
            icon = "󰩉 ",
            key = "g",
          },
          {
            action = function()
              vim.cmd("checkhealth")
            end,
            desc = " Check Health",
            icon = " ",
            key = "h",
          },
          {
            action = function()
              vim.cmd("Telescope keymaps")
            end,
            desc = " Key Mappings",
            icon = " ",
            key = "k",
          },
          {
            action = "lua LazyVim.pick.config_files()()",
            desc = " Open Config",
            icon = " ",
            key = "c",
          },
          {
            action = function()
              vim.cmd("Telescope colorscheme")
            end,
            desc = " Colorscheme",
            icon = " ",
            key = "t",
          },
          {
            action = function()
              vim.api.nvim_input("<cmd>Lazy<cr>")
            end,
            desc = " Lazy",
            icon = "󰒲 ",
            key = "l",
          },
          {
            action = function()
              vim.api.nvim_input("<cmd>qa<cr>")
            end,
            desc = " Quit Neovim",
            icon = "󰩈 ",
            key = "q",
          },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          -- Footer content with added space
          return {
            "",
            "⚡ NoeVim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
          },
            -- Apply Gruvbox white color to dashboard highlights
            vim.cmd([[
            highlight DashboardHeader guifg=#ebe2be
            highlight DashboardFooter guifg=#ebe2be
            highlight DashboardProjectTitle guifg=#ebe2be
            highlight DashboardProjectTitleIcon guifg=#ebe2be
            highlight DashboardProjectIcon guifg=#ebe2be
            highlight DashboardMruTitle guifg=#ebe2be
            highlight DashboardMruIcon guifg=#ebe2be
            highlight DashboardFiles guifg=#ebe2be
            highlight DashboardShortCutIcon guifg=#ebe2be
            highlight DashboardDesc guifg=#ebe2be
            highlight DashboardKey guifg=#ebe2be
            highlight DashboardIcon guifg=#ebe2be
            highlight DashboardShortCut guifg=#ebe2be
          ]])
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
}
