return {
  "folke/noice.nvim",
  event = "VeryLazy",
  config = function()
    require("noice").setup({
      messages = {
        enabled = false, -- enables the Noice messages UI
        view = "notify", -- default view for messages
        view_error = "notify", -- view for errors
        view_warn = "notify", -- view for warnings
        view_history = "messages", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
      popupmenu = {
        enabled = false, -- enables the Noice popupmenu UI
      },
      notify = {
        enabled = false,
        view = "notify",
      },
      routes = {
        {
          filter = {
            event = "notify",
          },
          opts = {
            skip = true,
          },
        },
      },
      presets = {
        lsp_doc_border = true,
      },
    })

    -- Key mappings for Noice
    vim.api.nvim_set_keymap('n', '<leader>dn', ':NoiceDismiss<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>dnd', ':lua ToggleNoice()<CR>', { noremap = true, silent = true })

    -- Toggle function for Noice
    local noice_enabled = true
    _G.ToggleNoice = function()
      if noice_enabled then
        vim.cmd("NoiceDisable")
        noice_enabled = false
        print("Noice Disabled")
      else
        vim.cmd("NoiceEnable")
        noice_enabled = true
        print("Noice Enabled")
      end
    end
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  }
}
