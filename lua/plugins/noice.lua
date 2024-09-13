return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
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
          style = "rounded",
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
          style = "rounded",
          text = {
            top = " Completion ",
            top_align = "center",
          },
        },
      },
      notify = {
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = "auto",
          height = "auto",
        },
        border = {
          style = "rounded",
          text = {
            top = " Notification ",
            top_align = "center",
          },
        },
      },
    },
    notify = {
      enabled = false,
    },
    lsp = {
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
            style = "rounded",
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
            style = "rounded",
            text = {
              top = " Completion ",
              top_align = "center",
            },
          },
        },
        notify = {
          position = {
            row = "50%",
            col = "50%",
          },
          size = {
            width = "auto",
            height = "auto",
          },
          border = {
            style = "rounded",
            text = {
              top = " Notification ",
              top_align = "center",
            },
          },
        },
      },
      progress = {
        enabled = false,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      lsp_doc_border = true,
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  },
  keys = {
    { "<leader>sn", false },
    { "<leader>sna", false },
    { "<leader>snd", false },
    { "<leader>snh", false },
    { "<leader>snl", false },
    {
      "<leader>nl",
      function()
        require("noice").cmd("last")
      end,
      desc = "Last Message",
    },
    {
      "<leader>nd",
      function()
        require("noice").cmd("dismiss")
      end,
      desc = "Dismiss All",
    },
    {
      "<leader>nt",
      function()
        require("noice").cmd("pick")
      end,
      desc = "Noice Picker",
    },
  },
  config = function(_, opts)
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
}
