local h = vim.api.nvim_set_hl

require("config.lazy")

-- Colorscheme
local colorscheme = "kanagawa-wave"

vim.cmd("colorscheme " .. colorscheme)

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

h(0, "MatchParen", { fg = "#FF9D3C", bg = "#353534", bold = true })

h(0, "YankyYanked", { fg = "#000000", bg = "#F6C177", bold = true })
h(0, "YankyPut", { fg = "#000000", bg = "#F6C177", bold = true })

h(0, "WinSeparator", { fg = "#1F3442", bg = "NONE", bold = true })
h(0, "Visual", { bg = "#525251", fg = nil })
h(0, "VisualMatch", { bg = "#353534", fg = nil })
h(0, "Search", { bg = "#595959", fg = nil })
h(0, "CurSearch", { fg = "#000000", bg = "#FF9D3C" })
h(0, "SnacksPickerListCursorLine", { bg = "#202030" })

h(0, "SnacksPickerPrompt", { fg = "#ff79c6" })

h(0, "NoiceCmdlineIcon", { fg = "#ff79c6", bg = nil })
h(0, "NoiceCmdlinePopupTitleCmdline", { fg = "#ffb86c", bg = nil })
h(0, "NoiceCmdlinePopupBorderCmdline", { fg = "#6272a4", bg = nil })

h(0, "GitSignsAdd", { fg = "#04b004", bg = "#000000" })
h(0, "GitSignsChange", { fg = "#e08300", bg = "#000000" })
h(0, "GitSignsDelete", { fg = "#ff0000", bg = "#000000" })
h(0, "GitSignsCurrentLineBlame", { fg = "#888888", bg = nil, italic = true })

h(0, "NeoTreeFloatBorder", { fg = "#6272a4", bg = nil })
h(0, "NeoTreeFloatTitle", { fg = "#ffb86c", bg = nil })
h(0, "NeoTreeCursorLine", { bg = "#202030" })

h(0, "NormalFloat", { bg = nil })
h(0, "FloatBorder", { fg = "#6272a4", bg = nil })
h(0, "CursorLineNr", { fg = "#fcb205", bg = "#202030" })

h(0, "FloatTitle", { fg = "#ffb86c", bg = nil })

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
h(0, "IblIndent", { fg = "#152A36" })

-- Custom Cmp hghlights, markdown erases them
h(0, "BlinkCmpKind", { fg = "#90CAE1" })
h(0, "BlinkCmpKindVariable", { fg = "#90CAE1" })
h(0, "BlinkCmpKindMethod", { fg = "#FFA065" })
h(0, "BlinkCmpKindFunction", { fg = "#FFA065" })
h(0, "BlinkCmpKindConstructor", { fg = "#FFA065" })
h(0, "BlinkCmpKindSnippet", { fg = "#E46876" })
h(0, "BlinkCmpKindKeyword", { fg = "#D3859B" })
h(0, "BlinkCmpKindField", { fg = "#7E9CD8" })
h(0, "BlinkCmpKindProperty", { fg = "#7E9CD8" })
h(0, "BlinkCmpKindEnumMember", { fg = "#D27E9A" })
h(0, "BlinkCmpKindEnum", { fg = "#D27E9A" })
h(0, "BlinkCmpKindFolder", { fg = "#967FB8" })
h(0, "BlinkCmpKindFile", { fg = "#967FB8" })
h(0, "BlinkCmpKindText", { fg = "#967FB8" })
h(0, "BlinkCmpKindClass", { fg = "#938AA9" })

h(0, "BlinkCmpKindReference", { fg = "#90CAE1" })
h(0, "BlinkCmpKindInterface", { fg = "#90CAE1" })
h(0, "BlinkCmpKindOperator", { fg = "#90CAE1" })
h(0, "BlinkCmpKindConstant", { fg = "#90CAE1" })
h(0, "BlinkCmpMenuDefault", { fg = "#90CAE1" })
h(0, "BlinkCmpKindDefault", { fg = "#90CAE1" })
h(0, "BlinkCmpKindStruct", { fg = "#90CAE1" })
h(0, "BlinkCmpKindModule", { fg = "#90CAE1" })
h(0, "BlinkCmpKindValue", { fg = "#90CAE1" })
h(0, "BlinkCmpKindEvent", { fg = "#90CAE1" })
h(0, "BlinkCmpKindColor", { fg = "#90CAE1" })
h(0, "BlinkCmpKindUnit", { fg = "#90CAE1" })

-- not transparent
h(0, "BlinkCmpMenu", { bg = "#000001" })
h(0, "BlinkCmpMenuBorder", { bg = "#000001", fg = "#6272a4" })

-- transparent
-- h(0, "BlinkCmpMenu", { bg = "#000000" })
-- h(0, "BlinkCmpMenuBorder", { bg = "#000000", fg = "#6272a4" })

h(0, "BlinkCmpMenuSelection", { bg = "#363646" })

h(0, "ISwapSelection", { bg = "#C34143" })
h(0, "ISwapHighlight", { fg = nil, bg = "#FF9D3C" })

-- vscode string color
-- hi(0, "String", { fg = "#CE9178" })

-- material gruvbox string color
-- hi(0, "String", { fg = "#89B482" })

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Define the Cursor highlight group
h(0, "Cursor", { fg = "NONE", bg = "#FFFFFF" })
h(0, "TelescopeMutedPath", { fg = "#888888" })

vim.cmd("set laststatus=0")

-- just remember to npm i @angular/language-server on your angular projects
require("lspconfig").angularls.setup({
  cmd = { "ngserver", "--stdio" },
  on_new_config = function(new_config, root_dir)
    local function find_node_modules(start_dir)
      return vim.fs.find("node_modules", { upward = true, path = start_dir })[1]
    end

    local node_modules_path = find_node_modules(root_dir)

    if node_modules_path then
      local angular_ls_path = node_modules_path .. "/@angular/language-service/lib"
      if vim.fn.isdirectory(angular_ls_path) == 1 then
        new_config.cmd = {
          "ngserver",
          "--stdio",
          "--tsProbeLocations",
          node_modules_path .. "/typescript/lib",
          "--ngProbeLocations",
          angular_ls_path,
        }
      else
        vim.defer_fn(function()
          print(
            "Node modules found, but @angular/language-service is missing.\nDon't forget to npm i @angular/language-server"
          )
        end, 2000)

        new_config.cmd = {
          "ngserver",
          "--stdio",
          "--tsProbeLocations",
          vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
          "--ngProbeLocations",
          vim.fn.stdpath("data")
            .. "/mason/packages/angular-language-server/node_modules/@angular/language-service/lib",
        }
      end
    else
      -- Fallback to global TypeScript and Angular Language Service
      vim.defer_fn(function()
        print("Don't forget to npm i @angular/language-server")
      end, 2000) -- 2000 milliseconds = 2 seconds

      new_config.cmd = {
        "ngserver",
        "--stdio",
        "--tsProbeLocations",
        vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
        "--ngProbeLocations",
        vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/node_modules/@angular/language-service/lib",
      }
    end
  end,
})

vim.cmd([[
  highlight RenderMarkdownH1Bg guibg=#502824 guifg=#fcd2b9 ctermbg=94 ctermfg=230  " Red
  highlight RenderMarkdownH3Bg guibg=#5a3d33 guifg=#d1c4a5 ctermbg=136 ctermfg=235 " Orange
  highlight RenderMarkdownH2Bg guibg=#37352f guifg=#d2ccab ctermbg=100 ctermfg=223 " Yellow
  highlight RenderMarkdownH4Bg guibg=#223b40 guifg=#bfd0d5 ctermbg=23 ctermfg=223  " Blue
  highlight RenderMarkdownH6Bg guibg=#22312d guifg=#bfd3ca ctermbg=65 ctermfg=235  " Green
  highlight RenderMarkdownH5Bg guibg=#362930 guifg=#dab9c6 ctermbg=96 ctermfg=230  " Violet
]])

local keys = require("lazyvim.plugins.lsp.keymaps").get()
keys[#keys + 1] = { "<C-k>", false, mode = "i" }
keys[#keys + 1] = { "<leader>ss", false, mode = "n" }
