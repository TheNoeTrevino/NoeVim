-- Makefile tooling: treesitter grammar + make-ls + checkmake linting.
--
-- make-ls (github.com/owenrumney/make-ls) is a real Makefile server: hover on
-- targets/variables/automatic-variables, completion, go-to-definition,
-- find-references, document symbols. checkmake covers linting on top
-- (minphony, phonydeclared, maxbodylength, timestampexpanded).
--
-- Not autotools_ls: despite nvim-lspconfig listing `make` in its filetypes, it's
-- an *autoconf* server (tree_sitter_autoconf grammar, AC_*-macro-only schema),
-- so on a Makefile it attaches and returns nothing -- measured, 0 hovers and 0
-- completions.
--
-- Nothing here touches indentation: Neovim's builtin ftplugin/make.vim already
-- sets `noexpandtab softtabstop=0 shiftwidth=0`, which is the rule that matters
-- in a Makefile (recipes require hard tabs).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "make" } },
  },
  {
    "mason.nvim",
    opts = { ensure_installed = { "checkmake" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Not in mason or the nvim-lspconfig registry, so the whole config is
        -- supplied here and `mason = false` keeps lsp-config.lua from trying to
        -- look it up. Install with:
        --   go install github.com/owenrumney/make-ls/cmd/make-ls@latest
        -- Speaks plain stdio, no flags. Going through opts.servers (rather than
        -- a bare vim.lsp.start autocmd) means it picks up the shared capabilities
        -- and the `*` keymap overrides from lsp-config.lua.
        make_ls = {
          cmd = { "make-ls" },
          filetypes = { "make" },
          root_markers = { "Makefile", "makefile", "GNUmakefile", ".git" },
          mason = false,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        make = { "checkmake" },
      },
      linters = {
        -- nvim-lint ships this as  --format='{{...}}\n'  which is broken here in
        -- two ways. The single quotes are literal (it spawns without a shell, so
        -- nothing strips them), and the trailing newline can't survive mason's
        -- checkmake.CMD batch wrapper -- cmd.exe truncates the argument there.
        -- Either one makes cobra reject the flag, so checkmake prints its help
        -- text and you silently get zero diagnostics instead of an error.
        -- Unquoted and without the newline works; checkmake already terminates
        -- each violation with one, so the stock parser still returns one
        -- diagnostic per violation.
        checkmake = {
          args = { "--format={{.LineNumber}}:{{.Rule}}:{{.Violation}}" },
        },
      },
    },
  },
}
