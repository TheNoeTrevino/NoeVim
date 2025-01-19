return {
  "saghen/blink.cmp",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  dependencies = {
    "edte/blink-go-import.nvim",
    ft = "go",
    config = function()
      require("blink-go-import").setup()
    end,
  },
  opts = {
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
      accept = {},
      menu = {
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        border = "rounded",
        winblend = 10,
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        window = {
          border = "rounded",
          winblend = 10,
        },
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = false,
      },
    },

    -- experimental signature help support
    -- signature = { enabled = true },

    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      default = { "lsp", "path", "snippets", "buffer", "go_pkgs" },
      providers = {
        go_pkgs = {
          module = "blink-go-import",
          name = "Import",
        },
      },
      cmdline = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        if type == ":" then
          return { "cmdline" }
        end
        return {}
      end,
    },

    keymap = {
      preset = "super-tab",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
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
  },
}
