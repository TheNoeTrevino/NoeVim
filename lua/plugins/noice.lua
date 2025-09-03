return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    cmdline = {
      view = "cmdline",
    },
    lsp = {
      hover = {
        enabled = false,
        silent = false, -- set to true to not show a message if hover is not available
        view = nil, -- when nil, use defaults from documentation
        ---@type NoiceViewOptions
        opts = {
          border = "single",
        }, -- merged with defaults from documentation
      },
      views = {
        cmdline_popup = {
          position = {
            row = "50%",
            col = "50%",
          },
          size = {
            width = "auto",
            height = "auto",
          },
          border = {
            style = "single",
            text = {
              top = " Command ",
              top_align = "center",
            },
          },
        },
        popupmenu = {
          position = {
            row = "50%",
            col = "50%",
          },
          size = {
            width = "auto",
            height = "auto",
          },
          border = {
            style = "single",
            text = {
              top = " Completion ",
              top_align = "center",
            },
          },
        },
      },
      progress = {
        enabled = false,
      },
    },
    -- command line workaround
    routes = {
      {
        filter = { event = "msg_show", kind = "shell_out" },
        view = "notify",
        opts = { level = "info", title = "Terminal" },
      },
      {
        filter = { event = "msg_show", kind = "shell_err" },
        view = "notify",
        opts = { level = "error", title = "Stderror" },
      },
    },
    presets = {
      lsp_doc_border = true,
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  },
  config = function(_, opts)
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
}
