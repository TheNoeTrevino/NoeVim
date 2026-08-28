-- Configures LuaLS to support auto-completion and type checking
-- while editing your Neovim configuration.
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      -- Disable in workspaces that manage lua_ls themselves via .luarc.json
      -- (e.g. standalone plugin repos); lazydev otherwise injects
      -- workspace.ignoreDir = { "/lua" }, hiding the project's own modules.
      enabled = function(root_dir)
        if vim.g.lazydev_enabled ~= nil then
          return vim.g.lazydev_enabled
        end
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
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
