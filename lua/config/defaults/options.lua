-- Default options, loaded FIRST by config/options.lua so the personal options there
-- override these. Notable wiring:
--   formatexpr   -> v:lua.require'util.format'.formatexpr()
--   statuscolumn -> v:lua.require'util'.statuscolumn()  (Snacks-backed)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- auto format
vim.g.autoformat = true

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

-- if the completion engine supports the AI source, use that instead of inline
-- suggestions (read by plugins/copilot.lua to gate copilot's inline suggestions)
vim.g.ai_cmp = true

-- root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Set LSP servers to be ignored when used with `util.root.detectors.lsp`
-- for detecting the LSP root
vim.g.root_lsp_ignore = { "copilot" }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show the current document symbols location from Trouble in lualine
-- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard

-- Name the clipboard provider explicitly on WSL. Without this, the first thing
-- that touches a register (yanky's init_history) triggers Neovim's provider
-- auto-detection, which probes every candidate tool over the WSL interop layer
-- and cost ~1460ms on this machine. Declaring g:clipboard skips the probe
-- entirely (~0.3ms). Only the actual read/write still spawns win32yank.
-- Guarded on has("wsl") so the Arch laptop sharing this repo keeps wl-copy.
if not vim.env.SSH_CONNECTION and vim.fn.has("wsl") == 1 and vim.fn.executable("win32yank.exe") == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = { ["+"] = "win32yank.exe -i --crlf", ["*"] = "win32yank.exe -i --crlf" },
    paste = { ["+"] = "win32yank.exe -o --lf", ["*"] = "win32yank.exe -o --lf" },
    cache_enabled = 0, -- 0 keeps paste semantics identical to auto-detection; the win is skipping the probe
  }
end
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatexpr = "v:lua.require'util.format'.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.require'util'.statuscolumn()]]
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
