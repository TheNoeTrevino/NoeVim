return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  opts = function(_, opts)
    -- Add custom sections if nvim-navic is not available
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

    local function short_filepath()
      local filepath = vim.fn.expand("%:p")
      local components = vim.split(filepath, "/")
      local len = #components
      if len > 5 then
        components = { unpack(components, len - 4, len) }
        filepath = table.concat(components, "/")
        return "..." .. filepath
      end
      return filepath
    end

    opts.options.globalstatus = false
    -- Set custom options for lualine
    opts.options = vim.tbl_extend("force", opts.options or {}, {
      icons_enabled = true, -- Enable/disable icons in the statusline
      theme = "molokai", -- Theme for the statusline (you can change it to any available theme)
      component_separators = { left = "", right = "" }, -- Separators for components
      section_separators = { left = "", right = "" }, -- Separators for sections
      disabled_filetypes = {}, -- Filetypes to disable lualine for
      always_divide_middle = true, -- Ensure sections are always divided
    })

    -- Define sections
    opts.sections = vim.tbl_extend("force", opts.sections or {}, {
      lualine_a = { "mode" }, -- Mode (e.g., normal, insert)
      lualine_b = { "branch" }, -- Git branch
      lualine_c = vim.tbl_extend("force", opts.sections and opts.sections.lualine_c or {}, { short_filepath() }), -- Filename
      lualine_x = { "encoding", "fileformat", "filetype" }, -- File encoding, format, and type
      lualine_y = { "progress" }, -- Progress through the file (e.g., 50%)
      lualine_z = { "location" }, -- Line and column number
    })

    -- Define inactive sections
    opts.inactive_sections = vim.tbl_extend("force", opts.inactive_sections or {}, {
      lualine_a = {}, -- Inactive sections
      lualine_b = {},
      lualine_c = { "filename" }, -- Show filename in inactive windows
      lualine_x = { "location" }, -- Show location in inactive windows
      lualine_y = {},
      lualine_z = {},
    })
  end,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Optional, for file icons
    opt = true, -- Optional, load it when needed
  },
}
