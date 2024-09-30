---@diagnostic disable: missing-parameter
if vim.g.vscode then
  vim.api.nvim_set_keymap("o", "j", "h", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("o", "k", "j", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("o", "l", "k", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("o", ";", "l", { noremap = true, silent = true })
  vim.api.nvim_set_keymap(
    "n",
    "<esc>",
    ":noh<CR>",
    { noremap = true, silent = true, desc = "Escape and Clear hlsearch" }
  )
  vim.api.nvim_set_keymap(
    "i",
    "<esc>",
    "<esc>:noh<CR>",
    { noremap = true, silent = true, desc = "Escape and Clear hlsearch" }
  )

  vim.g.mapleader = " "

  vim.api.nvim_set_keymap("n", "<Leader>k", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<Leader>gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
  vim.opt.clipboard = "unnamedplus"
else
  require("config.lazy")
  require("colorizer").setup({
    user_default_options = { mode = "virtualtext" },
  })

  -- Colorscheme
  vim.cmd("colorscheme gruvbox")
  vim.api.nvim_set_hl(0, "Visual", { bg = "#454545", fg = nil })
  vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = "#ff79c6", bg = nil })
  vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = "#ff79c6", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = "#f8f8f2", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitleCmdline", { fg = "#ffb86c", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#ffb86c", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdline", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#f8f8f2", bg = nil, bold = true })
  vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "#f8f8f2", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#ffb86c", bg = nil })
  vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#ffb86c", bg = nil })
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#04b004", bg = nil })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#e08300", bg = nil })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff0000", bg = nil })
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#888888", bg = nil, italic = true })
  vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { fg = "#ffb86c", bg = nil })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = nil })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#6272a4", bg = nil })
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#090909", ctermbg = 0 })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fcb205", bg = nil })

  vim.api.nvim_set_hl(0, "CmpItemKind", { fg = "#91F2EB" })

  -- needed since markodwn removes the highlights
  vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#fcb500" })
  vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#fcb500" })
  vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#fcb500" })

  vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#fc58d6" })

  vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemMenuDefault", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindDefault", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#5bf5ea" })
  vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#5bf5ea" })

  vim.opt.cursorline = true
  vim.opt.cursorlineopt = "number"
end
