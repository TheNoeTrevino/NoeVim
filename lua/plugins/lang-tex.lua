return {
  -- Add BibTeX & LaTeX to treesitter, but let vimtex own LaTeX highlighting
  -- (treesitter's latex highlight is disabled to avoid conflicts).
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.highlight = opts.highlight or {}
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bibtex", "latex" })
      end
      if type(opts.highlight.disable) == "table" then
        vim.list_extend(opts.highlight.disable, { "latex" })
      else
        opts.highlight.disable = { "latex" }
      end
    end,
  },

  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading breaks inverse search
    config = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      -- Use Zathura for the PDF viewer with SyncTeX forward/inverse search
      -- (otherwise VimTeX falls back to xdg-open, which opens a browser).
      vim.g.vimtex_view_method = "zathura"
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        texlab = {
          keys = {
            { "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
    },
  },

  -- Track the tex-fmt binary with Mason so it's installed alongside the config.
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "tex-fmt" } },
  },

  -- Format LaTeX with tex-fmt (conform ships the formatter definition).
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft["tex"] = { "tex-fmt" }
    end,
  },
}
