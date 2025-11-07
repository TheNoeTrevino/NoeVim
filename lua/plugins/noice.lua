return {
  "folke/noice.nvim",
  event = "InsertEnter",
  opts = {
    views = {

      cmdline_popup = {
        position = {
          row = "50%",
          col = "50%",
        },
        -- size = {
        --   width = "auto",
        --   height = "auto",
        -- },
        border = {
          style = "single",
          -- text = {
          --   top_align = "center",
          -- },
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
    lsp = {
      hover = {
        enabled = true,
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
        enabled = true,
      },
      -- override = {
      --   ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      --   ["vim.lsp.util.stylize_markdown"] = true,
      --   ["cmp.entry.get_documentation"] = true,
      -- },
    },
    routes = {
      {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            local client = vim.tbl_get(message.opts, "progress", "client")
            return client == "lua_ls"
          end,
        },
        opts = { skip = true },
      },
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
    { "<leader>nh", "<cmd>Noice history<cr>", desc = "History" },
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
