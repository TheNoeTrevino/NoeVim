return {
  "folke/noice.nvim",
  event = "InsertEnter",
  opts = {
    cmdline = {
      view = "cmdline",
    },
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
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
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
      {
        -- vim-dadbod echoes "DB: Running query..." and "DB: Query '...' finished
        -- in 0.0XXs" on every run; dadbod-ui.nvim shows that timing inline (winbar
        -- + ghost text), so drop the redundant command-line echoes.
        filter = {
          event = "msg_show",
          any = {
            { find = "^DB: Running query" },
            { find = "^DB: Query .* finished in" },
            { find = "^DB: Query .* aborted after" },
          },
        },
        opts = { skip = true },
      },
    },
    presets = {
      lsp_doc_border = true,
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  },
  -- stylua: ignore
  keys = {
    -- suppress the base noice keys
    { "<leader>sn", false },
    { "<leader>sna", false },
    { "<leader>snd", false },
    { "<leader>snh", false },
    { "<leader>snl", false },
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
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
