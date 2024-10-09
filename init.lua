require("config.lazy")

-- Colorscheme
vim.cmd("colorscheme kanagawa-wave")

vim.api.nvim_set_hl(0, "YankyYanked", { fg = "#000000", bg = "#F6C177", bold = true }) -- Customize as needed
vim.api.nvim_set_hl(0, "YankyPut", { fg = "#000000", bg = "#F6C177", bold = true }) -- Customize as needed
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#1F3442", bg = "NONE", bold = true }) -- Customize as needed
vim.api.nvim_set_hl(0, "Visual", { bg = "#454545", fg = nil })
vim.api.nvim_set_hl(0, "Search", { fg = "#2E3436", bg = "#A8B665" })
vim.api.nvim_set_hl(0, "CurSearch", { fg = "#FFFFFF", bg = "#EA6962" })
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

-- Custom Cmp highlights, markdown erases them
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#fcb500" })
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#fcb500" })
vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#fcb500" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#fc58d6" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#D3859B" })
vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#44aaf2" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#44aaf2" })

-- Defaults, needed bc markdown erasure
vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemMenuDefault", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindDefault", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#5bf5ea" })
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#5bf5ea" })

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
