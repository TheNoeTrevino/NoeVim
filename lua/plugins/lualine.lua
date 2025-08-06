return {
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",
  optional = true,
  config = function()
    local icons = LazyVim.config.icons
    local navic = require("nvim-navic")
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
          refresh_time = 16, -- ~60fps
          events = {
            "WinEnter",
            "BufEnter",
            "BufWritePost",
            "SessionLoadPost",
            "FileChangedShellPost",
            "VimResized",
            "Filetype",
            "CursorMoved",
            "CursorMovedI",
            "ModeChanged",
          },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" }, --"branch"
        lualine_c = {
          function()
            local state = require("timerly.state")
            if state.progress == 0 then
              return vim.fn.expand("%:t")
            end

            local total = math.max(0, state.total_secs + 1)
            local mins = math.floor(total / 60)
            local secs = total % 60

            return string.format("%s %02d:%02d", state.mode:gsub("^%l", string.upper), mins, secs)
          end,
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {
          {
            function()
              local ok, api = pcall(require, "copilot.api")
              if not ok or not api.status or not api.status.data then
                return ""
              end

              local status = api.status.data.status
              return (status == "InProgress" and "󰪞") or (status == "Warning" and " ") or " "
            end,

            cond = function()
              local ok, clients = pcall(function()
                return require("vim.lsp").get_active_clients({ name = "copilot" })
              end)
              return ok and clients and #clients > 0
            end,
            color = function()
              local ok, api = pcall(require, "copilot.api")
              if not ok or not api.status or not api.status.data then
                return {}
              end

              local status = api.status.data.status
              return {
                fg = (status == "InProgress" and "#cba6f7") or (status == "Warning" and "#f38ba8") or "#a6e3a1",
              }
            end,
          },
          Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color("Debug") } end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },
        },
        lualine_y = {
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_z = {
          -- { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
      tabline = {},
      inactive_winbar = {},
      -- tabline = {},
      extensions = {},
    })
  end,
}
