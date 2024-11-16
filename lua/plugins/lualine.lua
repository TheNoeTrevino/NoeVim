return {
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",
  optional = true,
  opts = function(_, opts)
    -- Add custom sections if nvim-navic is not available
    local icons = LazyVim.config.icons
    if not vim.g.trouble_lualine then
      table.insert(opts.sections.lualine_c, {
        function()
          return require("nvim-navic").get_location()
        end,
        cond = function()
          return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
        end,
      })
    end

    vim.cmd([[
      hi RecordingIcon guifg=#ff0000
      hi RecordingText guibg=#000000
    ]])

    opts.options.globalstatus = true
    -- Set custom options for lualine
    opts.options = vim.tbl_extend("force", opts.options or {}, {
      icons_enabled = true, -- Enable/disable icons in the statusline
      theme = "auto", -- Theme for the statusline (you can change it to any available theme)
      component_separators = { left = "", right = "" }, -- Separators for components
      section_separators = { left = "", right = "" }, -- Separators for sections
      disabled_filetypes = {}, -- Filetypes to disable lualine for
      always_divide_middle = true, -- Ensure sections are always divided
    })

    -- Define sections
    opts.sections = vim.tbl_extend("force", opts.sections or {}, {
      lualine_a = { "mode" },
      lualine_b = { "branch" }, --"branch"
      lualine_c = {
        {
          function()
            local recording = vim.fn.reg_recording()
            if recording ~= "" then
              -- Using the highlight group for the icon only
              return "%#RecordingText# REC %*" .. "%#RecordingIcon#  %* " .. recording
            else
              local filename = vim.fn.expand("%:~:.") -- Display filename relative to the working directory
              if vim.bo.modified then
                filename = filename .. " [+]" -- Append modification indicator
              end
              return filename
            end
          end,
          cond = function()
            return true -- Always show this component
          end,
        },
      },
      lualine_x = {
        {
          function()
            local state = require("timerly.state")
            if state.progress == 0 then
              return ""
            end

            local total = math.max(0, state.total_secs + 1) -- Add 1 to sync with timer display
            local mins = math.floor(total / 60)
            local secs = total % 60

            return string.format("%s %02d:%02d", state.mode:gsub("^%l", string.upper), mins, secs)
          end,

          table.insert(opts.sections.lualine_x, get_timerly_status),
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
      }, -- Progress through the file (e.g., 50%)
      lualine_z = { "location" }, -- Line and column number
    })

    -- Define inactive sections
    opts.inactive_sections = vim.tbl_extend("force", opts.inactive_sections or {}, {
      lualine_a = { "mode" },
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          file_status = true, -- Displays file status (readonly status, modified status)
          newfile_status = false, -- Display new file status (new file means no write after created)
          path = 0, -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory

          shorting_target = 40, -- Shortens path to leave 40 spaces in the window
          -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = "[+]", -- Text to show when the file is modified.
            readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
            unnamed = "[No Name]", -- Text to show for unnamed buffers.
            newfile = "[New]", -- Text to show for newly created file before first write
          },
        },
      }, -- Show filename in inactive windows
      lualine_x = {}, -- Show location in inactive windows
      lualine_y = {
        -- { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        function()
          return os.date("%t")
        end,
      },
    })
  end,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Optional, for file icons
    opt = true, -- Optional, load it when needed
  },
}
