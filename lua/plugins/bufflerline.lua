return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
      { "<leader>bd", LazyVim.ui.bufremove, desc = "Delete Buffer" },
      { "n", "<leader>bD", "<cmd>:bd<cr>", desc = "Delete Buffer and Window" },
    },
    opts = {
      options = {
        style_preset = require("bufferline").style_preset.no_italic,
        close_command = function(n)
          LazyVim.ui.bufremove(n)
        end,
        right_mouse_command = function(n)
          LazyVim.ui.bufremove(n)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = LazyVim.config.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
        get_element_icon = function(opts)
          return LazyVim.config.icons.ft[opts.filetype]
        end,
      },
      highlights = {
        fill = {
          fg = "#282828",
          bg = "#000000",
        },
        background = {
          fg = "#a89984",
          bg = "#000000",
        },
        tab = {
          fg = "#a89984",
          bg = "#282828",
        },
        tab_selected = {
          fg = "#ebdbb2",
          bg = "#3c3836",
        },
        tab_separator = {
          fg = "#282a36",
          bg = "#000000",
        },
        tab_separator_selected = {
          fg = "#1e1e2e",
          bg = "#282a36",
          sp = "#ffffff",
          underline = true,
        },
        tab_close = {
          fg = "#fb4934",
          bg = "#282828",
        },
        close_button = {
          fg = "#fb4934",
          bg = "#000000",
        },
        close_button_visible = {
          fg = "#fb4934",
          bg = "#1d2021",
        },
        close_button_selected = {
          fg = "#fb4934",
          bg = "#3c3836",
        },
        buffer_visible = {
          fg = "#a89984",
          bg = "#1d2021",
        },
        buffer_selected = {
          fg = "#ebdbb2",
          bg = "#3c3836",
          bold = true,
        },
        diagnostic = {
          fg = "#a89984",
          bg = "#000000",
        },
        diagnostic_visible = {
          fg = "#a89984",
          bg = "#1d2021",
        },
        diagnostic_selected = {
          fg = "#ebdbb2",
          bg = "#3c3836",
          bold = true,
        },
        hint = {
          fg = "#a89984",
          sp = "#000000",
          bg = "#000000",
        },
        hint_visible = {
          fg = "#a89984",
          bg = "#1d2021",
        },
        hint_selected = {
          fg = "#ebdbb2",
          bg = "#3c3836",
          sp = "#000000",
          bold = true,
        },
        hint_diagnostic = {
          fg = "#a89984",
          sp = "#000000",
          bg = "#000000",
        },
        hint_diagnostic_visible = {
          fg = "#a89984",
          bg = "#1d2021",
        },
        hint_diagnostic_selected = {
          fg = "#ebdbb2",
          bg = "#3c3836",
          sp = "#000000",
          bold = true,
        },
        info = {
          fg = "#a89984",
          sp = "#000000",
          bg = "#000000",
        },
        info_visible = {
          fg = "#a89984",
          bg = "#1d2021",
        },
        info_selected = {
          fg = "#ebdbb2",
          bg = "#3c3836",
          sp = "#000000",
          bold = true,
        },
        info_diagnostic = {
          fg = "#a89984",
          sp = "#000000",
          bg = "#000000",
        },
        info_diagnostic_visible = {
          fg = "#a89984",
          bg = "#1d2021",
        },
        info_diagnostic_selected = {
          fg = "#ebdbb2",
          bg = "#3c3836",
          sp = "#000000",
          bold = true,
        },
        warning = {
          fg = "#a89984",
          sp = "#000000",
          bg = "#000000",
        },
        warning_visible = {
          fg = "#a89984",
          bg = "#1d2021",
        },
        warning_selected = {
          fg = "#ebdbb2",
          bg = "#3c3836",
          sp = "#000000",
          bold = true,
        },
        warning_diagnostic = {
          fg = "#a89984",
          sp = "#000000",
          bg = "#000000",
        },
        warning_diagnostic_visible = {
          fg = "#a89984",
          bg = "#1d2021",
        },
        warning_diagnostic_selected = {
          fg = "#ebdbb2",
          bg = "#3c3836",
          sp = "#000000",
          bold = true,
        },
        error = {
          fg = "#fb4934",
          bg = "#000000",
          sp = "#000000",
        },
        error_visible = {
          fg = "#fb4934",
          bg = "#1d2021",
        },
        error_selected = {
          fg = "#fb4934",
          bg = "#3c3836",
          sp = "#000000",
          bold = true,
        },
        error_diagnostic = {
          fg = "#fb4934",
          bg = "#000000",
          sp = "#000000",
        },
        error_diagnostic_visible = {
          fg = "#fb4934",
          bg = "#1d2021",
        },
        error_diagnostic_selected = {
          fg = "#fb4934",
          bg = "#3c3836",
          sp = "#000000",
          bold = true,
        },
        modified = {
          fg = "#fabd2f",
          bg = "#000000",
        },
        modified_visible = {
          fg = "#fabd2f",
          bg = "#1d2021",
        },
        modified_selected = {
          fg = "#fabd2f",
          bg = "#3c3836",
        },
        duplicate_selected = {
          fg = "#a89984",
          bg = "#3c3836",
        },
        duplicate_visible = {
          fg = "#a89984",
          bg = "#1d2021",
        },
        duplicate = {
          fg = "#a89984",
          bg = "#000000",
        },
        separator_selected = {
          fg = "#1e1e2e",
          bg = "#3c3836",
        },
        separator_visible = {
          fg = "#1e1e2e",
          bg = "#1d2021",
        },
        separator = {
          fg = "#1e1e2e",
          bg = "#000000",
        },
        indicator_selected = {
          fg = "#a45310", -- one that we use
          bg = "#3c3836",
        },
        indicator_visible = {
          fg = "#ff8800",
          bg = "#1d2021",
        },
        pick_selected = {
          fg = "#fabd2f",
          bg = "#3c3836",
          bold = true,
        },
        pick_visible = {
          fg = "#fabd2f",
          bg = "#1d2021",
          bold = true,
        },
        pick = {
          fg = "#fabd2f",
          bg = "#000000",
          bold = true,
        },
        offset_separator = {
          fg = "#1d2021",
          bg = "#1d2021",
        },
        trunc_marker = {
          fg = "#a89984",
          bg = "#000000",
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(require("bufferline").setup, opts)
          end)
        end,
      })
    end,
  },
}
