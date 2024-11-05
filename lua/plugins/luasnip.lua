return {
  "L3MON4D3/LuaSnip",
  event = "VeryLazy",
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  build = "make install_jsregexp",
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

    vim.api.nvim_set_keymap(
      "i",
      "<Tab>",
      [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']],
      { expr = true, silent = true }
    )
    vim.api.nvim_set_keymap("s", "<Tab>", [[<cmd>lua require'luasnip'.jump(1)<Cr>]], { silent = true })
    vim.api.nvim_set_keymap("i", "<S-Tab>", [[<cmd>lua require'luasnip'.jump(-1)<Cr>]], { silent = true })
    vim.api.nvim_set_keymap("s", "<S-Tab>", [[<cmd>lua require'luasnip'.jump(-1)<Cr>]], { silent = true })

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
}
