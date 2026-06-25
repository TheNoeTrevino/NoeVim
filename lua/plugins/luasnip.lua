-- LuaSnip. Single source of truth: the base spec (originally vendored from
-- LazyVim's coding.luasnip extra: friendly-snippets, cmp/blink integration,
-- snippet actions) plus the personal setup and custom snippets.
local Util = require("util")
return {
  -- disable builtin snippet support
  { "garymjr/nvim-snippets", optional = true, enabled = false },

  -- add luasnip
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = (not Util.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- add snippet_forward action
  {
    "L3MON4D3/LuaSnip",
    opts = function()
      Util.cmp.actions.snippet_forward = function()
        if require("luasnip").jumpable(1) then
          vim.schedule(function()
            require("luasnip").jump(1)
          end)
          return true
        end
      end
      Util.cmp.actions.snippet_stop = function()
        if require("luasnip").expand_or_jumpable() then -- or just jumpable(1) is fine?
          require("luasnip").unlink_current()
          return true
        end
      end
    end,
  },

  -- nvim-cmp integration
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }
      table.insert(opts.sources, { name = "luasnip" })
    end,
    -- stylua: ignore
    keys = {
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },

  -- blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      snippets = {
        preset = "luasnip",
      },
    },
  },

  -- personal setup, tab keymaps, and custom snippets
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    build = "make install_jsregexp",
    lazy = true,
    config = function()
      -- If you forget:
      -- https://www.youtube.com/watch?v=FmHhonPjvvA&ab_channel=Vimjoyer
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local parse = ls.parser.parse_snippet
      local extras = require("luasnip.extras")
      local rep = extras.rep
      local fmt = require("luasnip.extras.fmt").fmt
      local c = ls.choice_node
      local f = ls.function_node
      local d = ls.dynamic_node
      local sn = ls.snippet_node

      ls.setup({
        update_events = { "TextChanged", "TextChangedI" },
      })

      vim.api.nvim_set_keymap(
        "i",
        "<Tab>",
        [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']],
        { expr = true, silent = true }
      )
      vim.api.nvim_set_keymap("s", "<Tab>", [[<cmd>lua require'luasnip'.jump(1)<Cr>]], { silent = true })
      vim.api.nvim_set_keymap("i", "<S-Tab>", [[<cmd>lua require'luasnip'.jump(-1)<Cr>]], { silent = true })
      vim.api.nvim_set_keymap("s", "<S-Tab>", [[<cmd>lua require'luasnip'.jump(-1)<Cr>]], { silent = true })

      ls.add_snippets("markdown", {
        s({ trig = "todo", name = "Todo List", dscr = "Todo Item" }, {
          t("- [ ] "),
          i(1, "todo"),
        }),
      })

      ls.add_snippets("go", {
        s({ trig = "err", name = "Error", dscr = "Throw an error" }, {
          t("if err != nil {"),
          t({ "", "\t" }),
          t('return errors.New("'),
          i(1),
          t('")'),
          t({ "", "" }),
          t("}"),
        }),

        s({ trig = "pf", name = "Formatted Print", dscr = "Insert a formatted print statement" }, {
          t('fmt.Printf("%#v\\n", '),
          i(1, "value"),
          t(")"),
        }),

        parse(
          { trig = "ife", name = "If Err", dscr = "Insert a basic if err not nil statement" },
          [[
     if err != nil {
       return err
     }
     ]]
        ),

        parse(
          { trig = "ifele", name = "If Err Log Error", dscr = "Insert a basic if err not nil statement with log.Error" },
          [[
     if err != nil {
       log.Fatal(err)
     }
     ]]
        ),

        parse(
          { trig = "ifelf", name = "If Err Log Fatal", dscr = "Insert a basic if err not nil statement with log.Fatal" },
          [[
     if err != nil {
       log.Fatal(err)
     }
     ]]
        ),

        s({ trig = "ifew", name = "If Err Wrapped", dscr = "Insert a if err not nil statement with wrapped error" }, {
          t("if err != nil {"),
          t({ "", '  return fmt.Errorf("failed to ' }),
          i(1, "message"),
          t(': %w", err)'),
          t({ "", "}" }),
        }),

        parse(
          { trig = "ma", name = "Main Package", dscr = "Basic main package structure" },
          [[
     package main

     import "fmt"

     func main() {
       fmt.Printf("%+v\n", "...")
     }
     ]]
        ),
      })
    end,
  },
}
