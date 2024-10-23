require("config.lazy")

-- Colorscheme
local colorscheme = "kanagawa-wave"

vim.cmd("colorscheme " .. colorscheme)

if colorscheme == "kanagawa-wave" then
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#1F3442", bg = "NONE", bold = true })
  -- typescript
  vim.api.nvim_set_hl(0, "@keyword.coroutine.tsx", { fg = "#53758D", italic = true })
  vim.api.nvim_set_hl(0, "@keyword.conditional.tsx", { fg = "#D27E9A", italic = true })
  vim.api.nvim_set_hl(0, "@keyword.exception.tsx", { fg = "#FF5D62", bold = true, italic = true })
  vim.api.nvim_set_hl(0, "@type.tsx", { fg = "#688E81" })
  vim.api.nvim_set_hl(0, "@type.builtin.tsx", { fg = "#90CAE1" })
  vim.api.nvim_set_hl(0, "@constructor.tsx", { bold = true })
  vim.api.nvim_set_hl(0, "@keyword.operator.tsx", { fg = "#C0A36E", italic = true, bold = true })
  -- python
  vim.api.nvim_set_hl(0, "@keyword.conditional.python", { fg = "#D27E9A", italic = true })
  vim.api.nvim_set_hl(0, "@keyword.repeat.python", { fg = "#53758D", italic = true })
  vim.api.nvim_set_hl(0, "@keyword.operator.python", { fg = "#C0A36E", italic = true, bold = true })
  vim.api.nvim_set_hl(0, "@type.python", { fg = "#688E81" })
  vim.api.nvim_set_hl(0, "@type.builtin.python", { fg = "#90CAE1" })
  vim.api.nvim_set_hl(0, "@constructor.python", { fg = "#7AA89F", bold = true })
  -- java
  vim.api.nvim_set_hl(0, "@keyword.conditional.java", { fg = "#D27E9A", italic = true })
  vim.api.nvim_set_hl(0, "@lsp.typemod.class.public.java", { fg = "#688E81", italic = true })
  vim.api.nvim_set_hl(0, "@lsp.typemod.class.typeArgument.java", { fg = "#90CAE1", italic = true })
  vim.api.nvim_set_hl(0, "@lsp.type.modifier.java", { fg = "#947FB8", italic = false })
  vim.api.nvim_set_hl(0, "@type.builtin.java", { fg = "#7EB4C9", italic = true })
end

vim.api.nvim_set_hl(0, "YankyYanked", { fg = "#000000", bg = "#F6C177", bold = true })
vim.api.nvim_set_hl(0, "YankyPut", { fg = "#000000", bg = "#F6C177", bold = true })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#1F3442", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "Visual", { bg = "#525251", fg = nil })
vim.api.nvim_set_hl(0, "Search", { bg = "#525251", fg = nil })
vim.api.nvim_set_hl(0, "CurSearch", { fg = "#000000", bg = "#FF9D3C" })
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

-- Custom Cmp highlights, markdown erases them
vim.api.nvim_set_hl(0, "CmpItemKind", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#FFA065" })
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#FFA065" })
vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#FFA065" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#fc58d6" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#D3859B" })
vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#44aaf2" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#44aaf2" })
vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#D27E9A" })
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#D27E9A" })
vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#967FB8" })
vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#967FB8" })
vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#967FB8" })

-- Defaults, needed bc markdown erasure
vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemMenuDefault", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindDefault", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#90CAE1" })
vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#90CAE1" })

-- Current changes (green)
vim.api.nvim_set_hl(0, "GitConflictCurrentLabel", { bg = "#337367", fg = nil })
vim.api.nvim_set_hl(0, "GitConflictCurrent", { bg = "#264033", fg = nil })

-- Incoming changes (baby blue)
vim.api.nvim_set_hl(0, "GitConflictIncomingLabel", { bg = "#326290", fg = nil })
vim.api.nvim_set_hl(0, "GitConflictIncoming", { bg = "#283B4D", fg = nil })

-- Ancestor label (purple/blue)
vim.api.nvim_set_hl(0, "GitConflictAncestorLabel", { bg = "#393939", fg = nil })
vim.api.nvim_set_hl(0, "GitConflictAncestor", { bg = "#545252", fg = nil })

-- Neo-tree conflict (can match incoming or ancestor)
vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { bg = "#326290", fg = nil })

-- vscode string color
-- vim.api.nvim_set_hl(0, "String", { fg = "#CE9178" })

-- material gruvbox string color
-- vim.api.nvim_set_hl(0, "String", { fg = "#89B482" })

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Define the Cursor highlight group
vim.api.nvim_set_hl(0, "Cursor", { fg = "NONE", bg = "#FFFFFF" })
