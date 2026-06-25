local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=main", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Cut-the-cord bootstrap (replaces lazyvim.config.init() now that LazyVim is gone):
--  * expose our util as the global `LazyVim` (safety net for any lingering global refs)
--  * load options before plugins (mapleader must be set before lazy maps <leader> keys)
--  * register the LazyFile event (BufReadPost/BufNewFile/BufWritePre) used by many specs
_G.LazyVim = require("util")
require("config.options")
do
  local Event = require("lazy.core.handler.event")
  Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

require("lazy").setup({
  spec = {
    -- Base-opts seeds, processed FIRST so the lang extras' opts FUNCTIONS (which index
    -- opts.formatters / opts.formatters_by_ft / opts.linters_by_ft directly) always find a
    -- table to write into. LazyVim used to guarantee this by loading its core formatting/
    -- linting specs before extras; our real base lives in plugins/format.lua + plugins/lint.lua
    -- (imported last via { import = "plugins" } so the user's opts still win on conflicts).
    { "stevearc/conform.nvim", opts = { formatters = {}, formatters_by_ft = {} } },
    { "mfussenegger/nvim-lint", opts = { linters_by_ft = {} } },
    -- Extras: vendored from LazyVim into lua/plugins/extras/ (no longer lazyvim.plugins.*).
    -- These used to come from both this list and lazyvim.json (:LazyExtras); now unified here.
    -- Lang
    { import = "plugins.extras.lang.java" },
    { import = "plugins.extras.lang.typescript" }, -- vtsls; dap block installs js-debug-adapter
    { import = "plugins.extras.lang.python" },
    { import = "plugins.extras.lang.sql" },
    { import = "plugins.extras.lang.go" },
    { import = "plugins.extras.lang.tailwind" },
    -- angular: npm install @angular/language-service --no-save (save-dev for projects needing the version)
    { import = "plugins.extras.lang.angular" },
    { import = "plugins.extras.lang.json" },
    { import = "plugins.extras.lang.docker" },
    { import = "plugins.extras.lang.dotnet" },
    { import = "plugins.extras.lang.rust" },
    { import = "plugins.extras.lang.toml" },
    -- Formatting
    { import = "plugins.extras.formatting.black" },
    { import = "plugins.extras.formatting.prettier" },
    -- Editor / Util
    { import = "plugins.extras.editor.neo-tree" },
    { import = "plugins.extras.editor.inc-rename" },
    { import = "plugins.extras.editor.dial" },
    { import = "plugins.extras.util.dot" },
    { import = "plugins.extras.util.rest" },
    -- Test / DAP / Coding / UI
    { import = "plugins.extras.test.core" },
    { import = "plugins.extras.dap.core" },
    { import = "plugins.extras.coding.luasnip" },
    { import = "plugins.extras.ui.treesitter-context" },
    { import = "plugins" },
  },
  defaults = {
    lazy = true,
  },
  checker = {
    enabled = true,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    title = " NoeVim ",
    title_pos = "center", ---@type "center" | "left" | "right"
    border = "single",
    backdrop = 50,
  },
})

-- Load keymaps + autocmds on VeryLazy (LazyVim used to do this from its setup()).
-- Deferred so plugins (Snacks, which-key, etc.) are available when our mappings reference them.
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.autocmds")
    require("config.keymaps")
  end,
})
