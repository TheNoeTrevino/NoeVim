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

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = { colorscheme = "kanagawa" } },
    -- Lang
    { import = "lazyvim.plugins.extras.lang.java" },
    -- { import = "lazyvim.plugins.extras.lang.typescript" }, -- why is this loading the chrome debugger??
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.sql" },
    { import = "lazyvim.plugins.extras.lang.go" },
    -- { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.util.dot" },
    -- npm install @angular/language-service --no-save
    -- for icris and other projects that need the version and such
    -- or just do save-dev usually
    -- { import = "lazyvim.plugins.extras.lang.angular" },
    { import = "lazyvim.plugins.extras.lang.json" },
    -- Formatting
    { import = "lazyvim.plugins.extras.formatting.black" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    -- Util
    { import = "lazyvim.plugins.extras.editor.inc-rename" },
    { import = "lazyvim.plugins.extras.editor.dial" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.coding.luasnip" },
    { import = "lazyvim.plugins.extras.editor.neo-tree" },
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    { import = "plugins" },
  },
  checker = {
    enabled = true,
  },
  ui = {
    title = " NoeVim ",
    title_pos = "center", ---@type "center" | "left" | "right"
    border = "single",
    backdrop = 50,
  },
})
