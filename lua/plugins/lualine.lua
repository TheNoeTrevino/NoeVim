return {
  "nvim-lualine/lualine.nvim",
  event = "UIEnter",
  optional = true,
  opts = function(_, opts)
    -- Add custom sections if nvim-navic is not available
    local icons = LazyVim.config.icons
    local harpoon_files = require("harpoon_files")
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
      lualine_a = { "branch" },
      lualine_b = {
        function()
          local state = require("timerly.state")
          if state.progress == 0 then
            return vim.fn.expand("%:t")
          end

          local total = math.max(0, state.total_secs + 1) -- Add 1 to sync with timer display
          local mins = math.floor(total / 60)
          local secs = total % 60

          return string.format("%s %02d:%02d", state.mode:gsub("^%l", string.upper), mins, secs)
        end,
      },
      lualine_c = {
        function()
          local recording = vim.fn.reg_recording()
          if recording ~= "" then
            -- Using the highlight group for the icon only
            return "%#RecordingText# REC %*" .. "%#RecordingIcon#  %* " .. recording
          end

          return harpoon_files.lualine_component()
        end,
      },
      lualine_x = { "diagnostics" },
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
  end,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Optional, for file icons
    opt = true, -- Optional, load it when needed
  },
}
