return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,       -- Enable/disable icons in the statusline
                theme = 'auto',             -- Theme for the statusline (you can change it to any available theme)
                component_separators = { left = '', right = '' }, -- Separators for components
                section_separators = { left = '', right = '' },  -- Separators for sections
                disabled_filetypes = {},    -- Filetypes to disable lualine for
                always_divide_middle = true,-- Ensure sections are always divided
            },
            sections = {
                lualine_a = {'mode'},       -- Mode (e.g., normal, insert)
                lualine_b = {'branch'},     -- Git branch
                lualine_c = {'filename'},   -- Filename
                lualine_x = {'encoding', 'fileformat', 'filetype'}, -- File encoding, format, and type
                lualine_y = {'progress'},   -- Progress through the file (e.g., 50%)
                lualine_z = {'location'}    -- Line and column number
            },
            inactive_sections = {
                lualine_a = {},             -- Inactive sections
                lualine_b = {},
                lualine_c = {'filename'},   -- Show filename in inactive windows
                lualine_x = {'location'},   -- Show location in inactive windows
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},                   -- Configure tabline if needed
            extensions = {}                 -- Extensions for additional features
        }
    end,
    dependencies = {
        'nvim-tree/nvim-web-devicons',     -- Optional, for file icons
        opt = true                         -- Optional, load it when needed
    },
}
