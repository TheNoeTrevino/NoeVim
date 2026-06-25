-- Configures LuaLS to support auto-completion and type checking
-- while editing your Neovim configuration.
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyPlugin", "LazySpec" } },
        { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
      },
    },
  },

  -- Register lazydev as a blink.cmp completion source for lua files.
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
}
