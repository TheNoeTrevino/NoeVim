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
    -- Base-opts seeds, processed FIRST so the lang specs' opts FUNCTIONS (which index
    -- opts.formatters / opts.formatters_by_ft / opts.linters_by_ft directly) always find a
    -- table to write into. The real base lives in plugins/format.lua + plugins/lint.lua.
    { "stevearc/conform.nvim", opts = { formatters = {}, formatters_by_ft = {} } },
    { "mfussenegger/nvim-lint", opts = { linters_by_ft = {} } },
    -- mason.nvim ensure_installed: some lang specs mutate this list via an opts function
    -- (table.insert), which now alphabetically precedes mason.lua. Seed an empty list so
    -- those inserts always find a table. opts_extend in mason.lua concatenates the rest.
    { "mason-org/mason.nvim", opts = { ensure_installed = {} } },
    -- Everything else is a flat file under lua/plugins/ (one file per plugin/topic),
    -- auto-discovered by this single import (lazy.nvim does not recurse into subdirs).
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
