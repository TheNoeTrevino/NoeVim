if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end

local h = vim.api.nvim_set_hl

require("config.lazy")

-- Colorscheme
local colorscheme = "kanagawa-wave"

vim.cmd("colorscheme " .. colorscheme)

-- Color Palette
local colors = {
  -- Core colors
  white = "#FFFFFF",
  black = "#000000",

  -- Grays and dark tones
  gray_dark = "#101010",
  gray_darker = "#131111",
  gray_light = "#888888",
  gray_medium = "#6272a4",

  -- Background variations
  bg_subtle = "#202030",
  bg_visual = "#525251",
  bg_visual_alt = "#353534",
  bg_search = "#595959",
  bg_selection = "#363646",
  bg_separator = "#1F3442",
  bg_cmp = "#000001",

  -- UI element backgrounds
  bg_conflict_current = "#264033",
  bg_conflict_current_label = "#337367",
  bg_conflict_incoming = "#283B4D",
  bg_conflict_incoming_label = "#326290",
  bg_conflict_ancestor = "#545252",
  bg_conflict_ancestor_label = "#393939",

  -- Indent guides
  indent_scope = "#426787",
  indent_normal = "#152A36",

  -- Syntax colors
  blue = "#7E9CD8",
  blue_light = "#90CAE1",
  blue_bright = "#7EB4C9",
  cyan = "#53758D",
  green = "#688E81",
  green_alt = "#7AA89F",
  orange = "#FFA065",
  orange_bright = "#FF9D3C",
  orange_warning = "#e08300",
  pink = "#D27E9A",
  purple = "#947FB8",
  purple_alt = "#967FB8",
  purple_dark = "#938AA9",
  red = "#FF5D62",
  red_bright = "#ff0000",
  red_git = "#C34143",
  yellow = "#C0A36E",
  yellow_alt = "#938056",
  yellow_bright = "#F6C177",
  yellow_cursor = "#fcb205",

  -- Dracula theme colors
  dracula_pink = "#ff79c6",
  dracula_orange = "#ffb86c",

  -- Git colors
  git_add = "#04b004",

  -- Markdown header backgrounds
  md_h1_bg = "#502824",
  md_h1_fg = "#fcd2b9",
  md_h2_bg = "#37352f",
  md_h2_fg = "#d2ccab",
  md_h3_bg = "#5a3d33",
  md_h3_fg = "#d1c4a5",
  md_h4_bg = "#223b40",
  md_h4_fg = "#bfd0d5",
  md_h5_bg = "#362930",
  md_h5_fg = "#dab9c6",
  md_h6_bg = "#22312d",
  md_h6_fg = "#bfd3ca",

  -- Additional completion colors
  cmp_snippet = "#E46876",
  cmp_keyword_alt = "#D3859B",
}

if colorscheme == "kanagawa-wave" or "kanagawa-dragon" then
  h(0, "WinSeparator", { fg = colors.bg_separator, bg = "NONE", bold = true })
  -- typescript
  --
  h(0, "@keyword.coroutine.tsx", { fg = colors.cyan, italic = true })
  h(0, "@keyword.coroutine.typescript", { fg = colors.cyan, italic = true })
  h(0, "@keyword.conditional.tsx", { fg = colors.pink, italic = true })
  h(0, "@keyword.conditional.lua", { fg = colors.pink, italic = true })
  h(0, "@keyword.exception.tsx", { fg = colors.red, bold = true, italic = true })
  h(0, "@type.tsx", { fg = colors.green })
  h(0, "@type.builtin.tsx", { fg = colors.blue_light })
  h(0, "@constructor.tsx", { bold = true })
  h(0, "@keyword.operator.tsx", { fg = colors.yellow, italic = true, bold = true })

  -- python
  h(0, "@keyword.conditional.python", { fg = colors.pink, italic = true })
  h(0, "@keyword.conditional.python", { fg = colors.pink, italic = true })
  h(0, "@keyword.repeat.python", { fg = colors.cyan, italic = true })
  h(0, "@keyword.repeat.lua", { fg = colors.cyan, italic = true })
  h(0, "@keyword.operator.python", { fg = colors.yellow, italic = true, bold = true })
  h(0, "@type.python", { fg = colors.green })
  h(0, "@type.builtin.python", { fg = colors.blue_light })
  h(0, "@constructor.python", { fg = colors.green_alt, bold = true })
  h(0, "@type.builtin.python", { fg = colors.yellow_alt })

  -- java
  h(0, "@keyword.conditional.java", { fg = colors.pink, italic = true })
  h(0, "@lsp.typemod.class.public.java", { fg = colors.green, italic = true })
  h(0, "@lsp.typemod.class.typeArgument.java", { fg = colors.blue_light, italic = true })
  h(0, "@lsp.type.modifier.java", { fg = colors.purple, italic = false })
  h(0, "@type.builtin.java", { fg = colors.blue_bright, italic = true })
end

h(0, "MatchParen", { fg = colors.orange_bright, bg = colors.bg_visual_alt, bold = true })

h(0, "YankyYanked", { fg = colors.black, bg = colors.yellow_bright, bold = true })
h(0, "YankyPut", { fg = colors.black, bg = colors.yellow_bright, bold = true })

h(0, "Visual", { bg = colors.bg_visual, fg = nil })
h(0, "VisualMatch", { bg = colors.bg_visual_alt, fg = nil })
h(0, "Search", { bg = colors.bg_search, fg = nil })
h(0, "CurSearch", { fg = colors.black, bg = colors.orange_bright })
h(0, "SnacksPickerListCursorLine", { bg = colors.bg_subtle })

h(0, "SnacksPickerPrompt", { fg = colors.dracula_pink })

h(0, "NoiceCmdlineIcon", { fg = colors.dracula_pink, bg = nil })
h(0, "NoiceCmdlinePopupTitleCmdline", { fg = colors.dracula_orange, bg = nil })
h(0, "NoiceCmdlinePopupBorderCmdline", { fg = colors.gray_medium, bg = nil })

h(0, "GitSignsAdd", { fg = colors.git_add, bg = nil })
h(0, "GitSignsChange", { fg = colors.orange_warning, bg = nil })
h(0, "GitSignsDelete", { fg = colors.red_bright, bg = nil })
h(0, "GitSignsCurrentLineBlame", { fg = colors.gray_light, bg = nil, italic = true })

h(0, "NeoTreeFloatBorder", { fg = colors.gray_medium, bg = nil })
h(0, "NeoTreeFloatTitle", { fg = colors.dracula_orange, bg = nil })
h(0, "NeoTreeCursorLine", { bg = colors.bg_subtle })

h(0, "NormalFloat", { bg = nil })
h(0, "FloatBorder", { fg = colors.gray_medium, bg = nil })
h(0, "CursorLineNr", { fg = colors.yellow_cursor, bg = colors.bg_subtle })

h(0, "FloatTitle", { fg = colors.dracula_orange, bg = nil })

-- Current changes (green)
h(0, "GitConflictCurrentLabel", { bg = colors.bg_conflict_current_label, fg = nil })
h(0, "GitConflictCurrent", { bg = colors.bg_conflict_current, fg = nil })

-- Incoming changes (baby blue)
h(0, "GitConflictIncomingLabel", { bg = colors.bg_conflict_incoming_label, fg = nil })
h(0, "GitConflictIncoming", { bg = colors.bg_conflict_incoming, fg = nil })

-- Ancestor label (purple/blue)
h(0, "GitConflictAncestorLabel", { bg = colors.bg_conflict_ancestor_label, fg = nil })
h(0, "GitConflictAncestor", { bg = colors.bg_conflict_ancestor, fg = nil })

-- Neo-tree conflict (can match incoming or ancestor)
h(0, "NeoTreeGitConflict", { bg = colors.bg_conflict_incoming_label, fg = nil })

h(0, "GlancePreviewNormal", { bg = colors.gray_darker, fg = nil })
h(0, "GlanceListNormal", { bg = colors.gray_dark, fg = nil })
h(0, "GlanceListEndOfBuffer", { bg = colors.gray_dark, fg = nil })

h(0, "GlanceListBorderBottom", { bg = colors.gray_dark, fg = colors.bg_separator })
h(0, "GlanceBorderTop", { bg = colors.gray_dark, fg = colors.bg_separator })
h(0, "GlancePreviewBorderBottom", { bg = colors.gray_dark, fg = colors.bg_separator })

h(0, "IblScope", { fg = colors.indent_scope })
h(0, "IblIndent", { fg = colors.indent_normal })

-- Custom Cmp hghlights, markdown erases them
h(0, "BlinkCmpKind", { fg = colors.blue_light })
h(0, "BlinkCmpKindVariable", { fg = colors.blue_light })
h(0, "BlinkCmpKindMethod", { fg = colors.orange })
h(0, "BlinkCmpKindFunction", { fg = colors.orange })
h(0, "BlinkCmpKindConstructor", { fg = colors.orange })
h(0, "BlinkCmpKindSnippet", { fg = colors.cmp_snippet })
h(0, "BlinkCmpKindKeyword", { fg = colors.cmp_keyword_alt })
h(0, "BlinkCmpKindField", { fg = colors.blue })
h(0, "BlinkCmpKindProperty", { fg = colors.blue })
h(0, "BlinkCmpKindEnumMember", { fg = colors.pink })
h(0, "BlinkCmpKindEnum", { fg = colors.pink })
h(0, "BlinkCmpKindFolder", { fg = colors.purple_alt })
h(0, "BlinkCmpKindFile", { fg = colors.purple_alt })
h(0, "BlinkCmpKindText", { fg = colors.purple_alt })
h(0, "BlinkCmpKindClass", { fg = colors.purple_dark })

h(0, "BlinkCmpKindReference", { fg = colors.blue_light })
h(0, "BlinkCmpKindInterface", { fg = colors.blue_light })
h(0, "BlinkCmpKindOperator", { fg = colors.blue_light })
h(0, "BlinkCmpKindConstant", { fg = colors.blue_light })
h(0, "BlinkCmpMenuDefault", { fg = colors.blue_light })
h(0, "BlinkCmpKindDefault", { fg = colors.blue_light })
h(0, "BlinkCmpKindStruct", { fg = colors.blue_light })
h(0, "BlinkCmpKindModule", { fg = colors.blue_light })
h(0, "BlinkCmpKindValue", { fg = colors.blue_light })
h(0, "BlinkCmpKindEvent", { fg = colors.blue_light })
h(0, "BlinkCmpKindColor", { fg = colors.blue_light })
h(0, "BlinkCmpKindUnit", { fg = colors.blue_light })

-- not transparent
h(0, "BlinkCmpMenu", { bg = colors.bg_cmp })
h(0, "BlinkCmpMenuBorder", { bg = colors.bg_cmp, fg = colors.gray_medium })

-- transparent
-- h(0, "BlinkCmpMenu", { bg = colors.black })
-- h(0, "BlinkCmpMenuBorder", { bg = colors.black, fg = colors.gray_medium })

h(0, "BlinkCmpMenuSelection", { bg = colors.bg_selection })

h(0, "ISwapSelection", { bg = colors.red_git })
h(0, "ISwapHighlight", { fg = nil, bg = colors.orange_bright })

-- vscode string color
-- hi(0, "String", { fg = "#CE9178" })

-- material gruvbox string color
-- hi(0, "String", { fg = "#89B482" })

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Define the Cursor highlight group
h(0, "Cursor", { fg = "NONE", bg = colors.white })

vim.cmd(
  string.format(
    [[
  highlight RenderMarkdownH1Bg guibg=%s guifg=%s ctermbg=94 ctermfg=230  " Red
  highlight RenderMarkdownH3Bg guibg=%s guifg=%s ctermbg=136 ctermfg=235 " Orange
  highlight RenderMarkdownH2Bg guibg=%s guifg=%s ctermbg=100 ctermfg=223 " Yellow
  highlight RenderMarkdownH4Bg guibg=%s guifg=%s ctermbg=23 ctermfg=223  " Blue
  highlight RenderMarkdownH6Bg guibg=%s guifg=%s ctermbg=65 ctermfg=235  " Green
  highlight RenderMarkdownH5Bg guibg=%s guifg=%s ctermbg=96 ctermfg=230  " Violet
]],
    colors.md_h1_bg,
    colors.md_h1_fg,
    colors.md_h3_bg,
    colors.md_h3_fg,
    colors.md_h2_bg,
    colors.md_h2_fg,
    colors.md_h4_bg,
    colors.md_h4_fg,
    colors.md_h6_bg,
    colors.md_h6_fg,
    colors.md_h5_bg,
    colors.md_h5_fg
  )
)

-- add this when you wanna install rosalyn
-- require("mason").setup({
--   registries = {
--     "github:mason-org/mason-registry",
--     "github:Crashdummyy/mason-registry",
--   },
-- })
--
require("inc_rename").setup({
  input_buffer_type = "snacks",
})
--
-- local minuet = require("minuet")
-- minuet.setup({
--   provider = "claude",
-- })
--
--makes a function that says hello
-- require("blink-cmp").setup({
--   keymap = {
--     -- Manually invoke minuet completion.
--     ["<c-y>"] = minuet.make_blink_map(),
--   },
--   sources = {
--     -- Enable minuet for autocomplete
--     default = { "lsp", "path", "buffer", "snippets", "minuet" },
--     -- For manual completion only, remove 'minuet' from default
--     providers = {
--       minuet = {
--         name = "minuet",
--         module = "minuet.blink",
--         async = true,
--         -- Should match minuet.config.request_timeout * 1000,
--         -- since minuet.config.request_timeout is in seconds
--         timeout_ms = 3000,
--         score_offset = 50, -- Gives minuet higher priority among suggestions
--       },
--     },
--   },
--   -- Recommended to avoid unnecessary request
--   completion = { trigger = { prefetch_on_insert = false } },
-- })
--

require("telescope").load_extension("git_worktree")

vim.keymap.set(
  "n",
  "<leader>gw",
  "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
  { desc = "Git Worktrees" }
)
vim.keymap.set(
  "n",
  "<leader>gW",
  "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
  { desc = "Create Git Worktree" }
)
