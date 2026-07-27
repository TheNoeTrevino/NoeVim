-- Makefile tooling.
--
-- autotools_ls is a documentation layer, not a semantic one: hover + completion
-- for make built-ins (.PHONY, $(realpath ...), automatic variables) and document
-- symbols for targets. No go-to-definition on targets. checkmake is the linter
-- that actually finds problems (minphony, phonydeclared, maxbodylength,
-- timestampexpanded).
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
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Installed by mason-lspconfig (package: autotools-language-server).
        -- Attaches to make/automake/config filetypes; roots on Makefile,
        -- configure.ac, Makefile.am, or *.mk.
        autotools_ls = {},
      },
    },
  },
}
