require("config.lazy")

-- Colorscheme
local colorscheme = "kanagawa-wave"

vim.cmd("colorscheme " .. colorscheme)
local h = vim.api.nvim_set_hl

if colorscheme == "kanagawa-wave" or "kanagawa-dragon" then
  h(0, "WinSeparator", { fg = "#1F3442", bg = "NONE", bold = true })
  -- typescript
  h(0, "@keyword.coroutine.tsx", { fg = "#53758D", italic = true })
  h(0, "@keyword.conditional.tsx", { fg = "#D27E9A", italic = true })
  h(0, "@keyword.exception.tsx", { fg = "#FF5D62", bold = true, italic = true })
  h(0, "@type.tsx", { fg = "#688E81" })
  h(0, "@type.builtin.tsx", { fg = "#90CAE1" })
  h(0, "@constructor.tsx", { bold = true })
  h(0, "@keyword.operator.tsx", { fg = "#C0A36E", italic = true, bold = true })

  -- python
  h(0, "@keyword.conditional.python", { fg = "#D27E9A", italic = true })
  h(0, "@keyword.repeat.python", { fg = "#53758D", italic = true })
  h(0, "@keyword.operator.python", { fg = "#C0A36E", italic = true, bold = true })
  h(0, "@type.python", { fg = "#688E81" })
  h(0, "@type.builtin.python", { fg = "#90CAE1" })
  h(0, "@constructor.python", { fg = "#7AA89F", bold = true })
  h(0, "@type.builtin.python", { fg = "#938056" })

  -- java
  h(0, "@keyword.conditional.java", { fg = "#D27E9A", italic = true })
  h(0, "@lsp.typemod.class.public.java", { fg = "#688E81", italic = true })
  h(0, "@lsp.typemod.class.typeArgument.java", { fg = "#90CAE1", italic = true })
  h(0, "@lsp.type.modifier.java", { fg = "#947FB8", italic = false })
  h(0, "@type.builtin.java", { fg = "#7EB4C9", italic = true })
end

h(0, "YankyYanked", { fg = "#000000", bg = "#F6C177", bold = true })
h(0, "YankyPut", { fg = "#000000", bg = "#F6C177", bold = true })
h(0, "WinSeparator", { fg = "#1F3442", bg = "NONE", bold = true })
h(0, "Visual", { bg = "#525251", fg = nil })
h(0, "Search", { bg = "#525251", fg = nil })
h(0, "CurSearch", { fg = "#000000", bg = "#FF9D3C" })
h(0, "TelescopePromptPrefix", { fg = "#ff79c6", bg = nil })
h(0, "NoiceCmdlineIcon", { fg = "#ff79c6", bg = nil })
h(0, "TelescopePromptNormal", { fg = "#f8f8f2", bg = nil })
h(0, "TelescopePromptBorder", { fg = "#6272a4", bg = nil })
h(0, "NoiceCmdlinePopupTitleCmdline", { fg = "#ffb86c", bg = nil })
h(0, "TelescopePromptTitle", { fg = "#ffb86c", bg = nil })
h(0, "TelescopeResultsBorder", { fg = "#6272a4", bg = nil })
h(0, "NoiceCmdlinePopupBorderCmdline", { fg = "#6272a4", bg = nil })
h(0, "TelescopePreviewBorder", { fg = "#6272a4", bg = nil })
h(0, "TelescopeSelection", { fg = "#f8f8f2", bg = nil, bold = true })
h(0, "TelescopeNormal", { fg = "#f8f8f2", bg = nil })
h(0, "TelescopeResultsTitle", { fg = "#ffb86c", bg = nil })
h(0, "TelescopePreviewTitle", { fg = "#ffb86c", bg = nil })
h(0, "GitSignsAdd", { fg = "#04b004", bg = nil })
h(0, "GitSignsChange", { fg = "#e08300", bg = nil })
h(0, "GitSignsDelete", { fg = "#ff0000", bg = nil })
h(0, "GitSignsCurrentLineBlame", { fg = "#888888", bg = nil, italic = true })
h(0, "NeoTreeFloatBorder", { fg = "#6272a4", bg = nil })
h(0, "NeoTreeFloatTitle", { fg = "#ffb86c", bg = nil })
h(0, "NormalFloat", { bg = nil })
h(0, "FloatBorder", { fg = "#6272a4", bg = nil })
h(0, "CursorLineNr", { fg = "#fcb205", bg = nil })

-- Custom Cmp hghlights, markdown erases them
h(0, "CmpItemKind", { fg = "#90CAE1" })
h(0, "CmpItemKindVariable", { fg = "#90CAE1" })
h(0, "CmpItemKindMethod", { fg = "#FFA065" })
h(0, "CmpItemKindFunction", { fg = "#FFA065" })
h(0, "CmpItemKindConstructor", { fg = "#FFA065" })
h(0, "CmpItemKindSnippet", { fg = "#E46876" })
h(0, "CmpItemKindKeyword", { fg = "#D3859B" })
h(0, "CmpItemKindField", { fg = "#7E9CD8" })
h(0, "CmpItemKindProperty", { fg = "#7E9CD8" })
h(0, "CmpItemKindEnumMember", { fg = "#D27E9A" })
h(0, "CmpItemKindEnum", { fg = "#D27E9A" })
h(0, "CmpItemKindFolder", { fg = "#967FB8" })
h(0, "CmpItemKindFile", { fg = "#967FB8" })
h(0, "CmpItemKindText", { fg = "#967FB8" })
h(0, "CmpItemKindClass", { fg = "#938AA9" })

-- Defaults, needed bc markdown erasure
h(0, "CmpItemKindReference", { fg = "#90CAE1" })
h(0, "CmpItemKindInterface", { fg = "#90CAE1" })
h(0, "CmpItemKindOperator", { fg = "#90CAE1" })
h(0, "CmpItemKindConstant", { fg = "#90CAE1" })
h(0, "CmpItemMenuDefault", { fg = "#90CAE1" })
h(0, "CmpItemKindDefault", { fg = "#90CAE1" })
h(0, "CmpItemKindStruct", { fg = "#90CAE1" })
h(0, "CmpItemKindModule", { fg = "#90CAE1" })
h(0, "CmpItemKindValue", { fg = "#90CAE1" })
h(0, "CmpItemKindEvent", { fg = "#90CAE1" })
h(0, "CmpItemKindColor", { fg = "#90CAE1" })
h(0, "CmpItemKindUnit", { fg = "#90CAE1" })

-- Current changes (green)
h(0, "GitConflictCurrentLabel", { bg = "#337367", fg = nil })
h(0, "GitConflictCurrent", { bg = "#264033", fg = nil })

-- Incoming changes (baby blue)
h(0, "GitConflictIncomingLabel", { bg = "#326290", fg = nil })
h(0, "GitConflictIncoming", { bg = "#283B4D", fg = nil })

-- Ancestor label (purple/blue)
h(0, "GitConflictAncestorLabel", { bg = "#393939", fg = nil })
h(0, "GitConflictAncestor", { bg = "#545252", fg = nil })

-- Neo-tree conflict (can match incoming or ancestor)
h(0, "NeoTreeGitConflict", { bg = "#326290", fg = nil })

h(0, "GlancePreviewNormal", { bg = "#131111", fg = nil })
h(0, "GlanceListNormal", { bg = "#101010", fg = nil })
h(0, "GlanceListEndOfBuffer", { bg = "#101010", fg = nil })

h(0, "GlanceListBorderBottom", { bg = "#101010", fg = "#1F3442" })
h(0, "GlanceBorderTop", { bg = "#101010", fg = "#1F3442" })
h(0, "GlancePreviewBorderBottom", { bg = "#101010", fg = "#1F3442" })

h(0, "IblScope", { fg = "#426787" })
h(0, "IblIndent", { fg = "#353A56" })

-- vscode string color
-- hi(0, "String", { fg = "#CE9178" })

-- material gruvbox string color
-- hi(0, "String", { fg = "#89B482" })

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Define the Cursor highlight group
h(0, "Cursor", { fg = "NONE", bg = "#FFFFFF" })
