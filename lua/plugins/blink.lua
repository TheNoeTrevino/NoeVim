return {
  "saghen/blink.cmp",
  event = "VeryLazy",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      enabled = true,
      keymap = {
        preset = "super-tab",

        ["<C-Space>"] = {
          function(cmp)
            cmp.show({
              providers = { "snippets" },
            })
          end,
        },
        ["<C-e>"] = { "hide", "fallback" },

        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-l>"] = { "select_prev", "fallback" },
        ["<C-k>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end,
      completion = {
        trigger = {
          show_on_blocked_trigger_characters = {},
          show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
        },
        menu = {
          auto_show = true, -- Inherits from top level `completion.menu.auto_show` config when not set
          draw = {
            columns = { { "label", "label_description", gap = 1 } },
          },
        },
      },
    },

    appearance = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = false,
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      accept = {},
      menu = {
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        border = "single",
        winblend = 10,
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        window = {
          border = "single",
          winblend = 10,
        },
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = true,
        show_with_selection = true,
        show_without_selection = false,
        show_with_menu = true,
        show_without_menu = true,
      },
    },
    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      default = { "lsp", "copilot", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          score_offset = 100,
          async = true,
        },
        dadbod = {
          name = "Dadbod",
          module = "vim_dadbod_completion.blink",
          score_offset = 50,
        },
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          kind = "Copilot",
          score_offset = 10,
          async = true,
        },
      },
    },

    keymap = {
      preset = "super-tab",
      ["<C-Space>"] = {
        function(cmp)
          cmp.show({
            providers = { "copilot" },
          })
        end,
      },
      ["<C-S>"] = {
        function(cmp)
          cmp.show({
            providers = { "snippets" },
          })
        end,
      },
      ["<C-h>"] = {
        function(cmp)
          cmp.show({
            providers = { "lsp" },
          })
        end,
      },
      ["<C-;>"] = {
        function()
          require("copilot.suggestion").accept_line()
        end,
        "hide",
      },
      ["<C-n>"] = {
        function()
          require("copilot.suggestion").next()
        end,
      },
      ["<C-p>"] = {
        function()
          require("copilot.suggestion").prev()
        end,
      },
      ["<C-e>"] = { "hide", "fallback" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-l>"] = { "select_prev", "fallback" },
      ["<C-k>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
  },
}
