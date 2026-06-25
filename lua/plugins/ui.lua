return {
  -- { "sainnhe/everforest" },
  -- Extra Colors
  -- Uncomment below to choose a colorscheme
  -- { "loctvl842/monokai-pro.nvim", event = "VeryLazy" },
  -- { "catppuccin/nvim", name = "catppuccin", event = "VeryLazy" },
  -- { "tokyonight.nvim", event = "VeryLazy" },
  -- { "Mofiqul/vscode.nvim", event = "VeryLazy" },
  -- { "bluz71/vim-moonfly-colors", event = "VeryLazy" },
  -- { "bluz71/vim-nightfly-colors", event = "VeryLazy" },
  -- { "ellisonleao/gruvbox.nvim", event = "VeryLazy" },
  -- { "sainnhe/gruvbox-material", event = "VeryLazy" },
  -- { "projekt0n/github-nvim-theme", event = "VeryLazy" },
  -- { "scottmckendry/cyberdream.nvim", event = "VeryLazy" },
  -- { "tiagovla/tokyodark.nvim", event = "VeryLazy" },
  -- { "sainnhe/edge", event = "VeryLazy" },
  -- { "EdenEast/nightfox.nvim", event = "VeryLazy" },
  -- { "marko-cerovac/material.nvim", event = "VeryLazy" },
  -- { "sainnhe/sonokai", event = "VeryLazy" },
  -- { "Shatur/neovim-ayu", event = "VeryLazy" },
  -- { "ChristianChiarulli/nvcode-color-schemes.vim", event = "VeryLazy" },
  -- { "comfysage/evergarden", event = "VeryLazy" },
  -- { "nyoom-engineering/oxocarbon.nvim", event = "VeryLazy" },
  -- { "nvimdev/zephyr-nvim", event = "VeryLazy" },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   lazy = true,
  --   config = function()
  --     require("rose-pine").setup({
  --       variant = "auto", -- auto, main, moon, or dawn
  --       dark_variant = "main", -- main, moon, or dawn
  --       dim_inactive_windows = false,
  --       extend_background_behind_borders = true,
  --       enable = {
  --         terminal = true,
  --         legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
  --         migrations = true, -- Handle deprecated options automatically
  --       },
  --       styles = {
  --         bold = true,
  --         italic = false,
  --         transparency = true,
  --       },
  --       highlight_groups = {
  --         -- String = { fg = "#FF0000" },
  --         -- Comment = { fg = "foam" },
  --         -- VertSplit = { fg = "muted", bg = "muted" },
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "https://gitlab.com/bartekjaszczak/distinct-nvim",
  --
  --   event = "VeryLazy",
  --   config = function()
  --     require("distinct").setup({
  --       doc_comments_different_color = true, -- Use different colour for documentation comments
  --     })
  --   end,
  -- },
  {
    "rebelot/kanagawa.nvim",
    -- Active colorscheme: load at startup (LazyVim used to apply it via colorscheme opt).
    lazy = false,
    priority = 1000,
    config = function()
      -- Custom palette. Kept local so every override below reads from one source.
      local c = {
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
        bg_visual = "#424241",
        bg_visual_alt = "#353534",
        bg_search = "#595959",
        bg_selection = "#363646",
        bg_separator = "#1F3442",
        bg_cmp = "#111111",

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

      require("kanagawa").setup({
        transparent = false, -- do not set background color
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = false },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {
              ui = {
                bg = "#111111",
                -- bg = "#000001",
              },
            },
            lotus = {},
            dragon = {},
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        -- All highlight overrides live here so they become part of the theme
        -- and survive colorscheme reloads (previously set once in init.lua).
        overrides = function()
          return {
            WinSeparator = { fg = c.bg_separator, bg = "NONE", bold = true },

            -- typescript
            ["@keyword.coroutine.tsx"] = { fg = c.cyan, italic = true },
            ["@keyword.coroutine.typescript"] = { fg = c.cyan, italic = true },
            ["@keyword.conditional.tsx"] = { fg = c.pink, italic = true },
            ["@keyword.conditional.lua"] = { fg = c.pink, italic = true },
            ["@keyword.conditional.go"] = { fg = c.pink, italic = true },
            ["@keyword.exception.tsx"] = { fg = c.red, bold = true, italic = true },
            ["@type.tsx"] = { fg = c.green },
            ["@type.builtin.tsx"] = { fg = c.blue_light },
            ["@constructor.tsx"] = { bold = true },
            ["@keyword.operator.tsx"] = { fg = c.yellow, italic = true, bold = true },
            ["@keyword.repeat.go"] = { fg = c.cyan, italic = true },

            -- angular
            ["@variable.angular"] = { fg = c.cyan, italic = true },

            -- python
            ["@keyword.conditional.python"] = { fg = c.pink, italic = true },
            ["@keyword.repeat.python"] = { fg = c.cyan, italic = true },
            ["@keyword.repeat.lua"] = { fg = c.cyan, italic = true },
            ["@keyword.operator.python"] = { fg = c.yellow, italic = true, bold = true },
            ["@type.python"] = { fg = c.green },
            ["@constructor.python"] = { fg = c.green_alt, bold = true },
            ["@type.builtin.python"] = { fg = c.yellow_alt },

            -- java
            ["@keyword.conditional.java"] = { fg = c.pink, italic = true },
            ["@lsp.typemod.class.public.java"] = { fg = c.green, italic = true },
            ["@lsp.typemod.class.typeArgument.java"] = { fg = c.blue_light, italic = true },
            ["@lsp.type.modifier.java"] = { fg = c.purple, italic = false },
            ["@type.builtin.java"] = { fg = c.blue_bright, italic = true },

            MatchParen = { fg = c.orange_bright, bg = c.bg_visual_alt, bold = true },

            YankyYanked = { fg = c.black, bg = c.yellow_bright, bold = true },
            YankyPut = { fg = c.black, bg = c.yellow_bright, bold = true },

            Visual = { bg = c.bg_visual },
            VisualMatch = { bg = c.bg_visual_alt },
            Search = { bg = c.bg_search },
            CurSearch = { fg = c.black, bg = c.orange_bright },
            SnacksPickerListCursorLine = { bg = c.bg_subtle },
            SnacksPickerPrompt = { fg = c.dracula_pink },

            NoiceCmdlineIcon = { fg = c.dracula_pink },
            NoiceCmdlinePopupTitleCmdline = { fg = c.dracula_orange },
            NoiceCmdlinePopupBorderCmdline = { fg = c.gray_medium },

            GitSignsAdd = { fg = c.git_add },
            GitSignsChange = { fg = c.orange_warning },
            GitSignsDelete = { fg = c.red_bright },
            GitSignsCurrentLineBlame = { fg = c.gray_light, italic = true },

            NeoTreeFloatBorder = { fg = c.gray_medium },
            NeoTreeFloatTitle = { fg = c.dracula_orange },
            NeoTreeCursorLine = { bg = c.bg_subtle },

            NormalFloat = { bg = "none" },
            FloatBorder = { fg = c.gray_medium },
            CursorLineNr = { fg = c.yellow_cursor, bg = c.bg_subtle },
            FloatTitle = { fg = c.dracula_orange },

            -- Current changes (green)
            GitConflictCurrentLabel = { bg = c.bg_conflict_current_label },
            GitConflictCurrent = { bg = c.bg_conflict_current },

            -- Incoming changes (baby blue)
            GitConflictIncomingLabel = { bg = c.bg_conflict_incoming_label },
            GitConflictIncoming = { bg = c.bg_conflict_incoming },

            -- Ancestor label (purple/blue)
            GitConflictAncestorLabel = { bg = c.bg_conflict_ancestor_label },
            GitConflictAncestor = { bg = c.bg_conflict_ancestor },

            -- Neo-tree conflict (can match incoming or ancestor)
            NeoTreeGitConflict = { bg = c.bg_conflict_incoming_label },

            GlancePreviewNormal = { bg = c.gray_darker },
            GlanceListNormal = { bg = c.gray_dark },
            GlanceListEndOfBuffer = { bg = c.gray_dark },
            GlanceListBorderBottom = { bg = c.gray_dark, fg = c.bg_separator },
            GlanceBorderTop = { bg = c.gray_dark, fg = c.bg_separator },
            GlancePreviewBorderBottom = { bg = c.gray_dark, fg = c.bg_separator },

            IblScope = { fg = c.indent_scope },
            IblIndent = { fg = c.indent_normal },

            -- Custom Cmp highlights, markdown erases them
            BlinkCmpKind = { fg = c.blue_light },
            BlinkCmpKindVariable = { fg = c.blue_light },
            BlinkCmpKindMethod = { fg = c.orange },
            BlinkCmpKindFunction = { fg = c.orange },
            BlinkCmpKindConstructor = { fg = c.orange },
            BlinkCmpKindSnippet = { fg = c.cmp_snippet },
            BlinkCmpKindKeyword = { fg = c.cmp_keyword_alt },
            BlinkCmpKindField = { fg = c.blue },
            BlinkCmpKindProperty = { fg = c.blue },
            BlinkCmpKindEnumMember = { fg = c.pink },
            BlinkCmpKindEnum = { fg = c.pink },
            BlinkCmpKindFolder = { fg = c.purple_alt },
            BlinkCmpKindFile = { fg = c.purple_alt },
            BlinkCmpKindText = { fg = c.purple_alt },
            BlinkCmpKindClass = { fg = c.purple_dark },
            BlinkCmpKindReference = { fg = c.blue_light },
            BlinkCmpKindInterface = { fg = c.blue_light },
            BlinkCmpKindOperator = { fg = c.blue_light },
            BlinkCmpKindConstant = { fg = c.blue_light },
            BlinkCmpMenuDefault = { fg = c.blue_light },
            BlinkCmpKindDefault = { fg = c.blue_light },
            BlinkCmpKindStruct = { fg = c.blue_light },
            BlinkCmpKindModule = { fg = c.blue_light },
            BlinkCmpKindValue = { fg = c.blue_light },
            BlinkCmpKindEvent = { fg = c.blue_light },
            BlinkCmpKindColor = { fg = c.blue_light },
            BlinkCmpKindUnit = { fg = c.blue_light },

            LspInlayHint = { fg = "#54546D", bg = "#1a1a1a" },
            LensLine = { fg = "#54546D", bg = "#1a1a1a" },

            -- not transparent
            BlinkCmpMenu = { bg = c.bg_cmp },
            BlinkCmpMenuBorder = { bg = c.bg_cmp, fg = c.gray_medium },
            BlinkCmpMenuSelection = { bg = c.bg_selection },

            ISwapSelection = { bg = c.red_git },
            ISwapHighlight = { bg = c.orange_bright },
            TreesitterContext = {},
            TreesitterContextSeparator = { fg = "#101F28" },

            -- Cursor
            Cursor = { fg = "NONE", bg = c.white },

            -- Markdown headers (replaces the old vim.cmd highlight block)
            RenderMarkdownH1Bg = { bg = c.md_h1_bg, fg = c.md_h1_fg, ctermbg = 94, ctermfg = 230 }, -- Red
            RenderMarkdownH2Bg = { bg = c.md_h2_bg, fg = c.md_h2_fg, ctermbg = 100, ctermfg = 223 }, -- Yellow
            RenderMarkdownH3Bg = { bg = c.md_h3_bg, fg = c.md_h3_fg, ctermbg = 136, ctermfg = 235 }, -- Orange
            RenderMarkdownH4Bg = { bg = c.md_h4_bg, fg = c.md_h4_fg, ctermbg = 23, ctermfg = 223 }, -- Blue
            RenderMarkdownH5Bg = { bg = c.md_h5_bg, fg = c.md_h5_fg, ctermbg = 96, ctermfg = 230 }, -- Violet
            RenderMarkdownH6Bg = { bg = c.md_h6_bg, fg = c.md_h6_fg, ctermbg = 65, ctermfg = 235 }, -- Green
          }
        end,
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          -- dark = "dragon", -- try "dragon" !
          -- light = "lotus",
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  -- { "nvzone/volt",    lazy = true },
  -- { "nvzone/timerly", cmd = "TimerlyToggle" },
  -- {
  --   "nvzone/showkeys",
  --   cmd = "ShowkeysToggle",
  --   opts = {
  --     timeout = 1,
  --     maxkeys = 5,
  --     position = "top-center",
  --   },
  -- },
  -- {
  --   "nvzone/typr",
  --   dependencies = "nvzone/volt",
  --   opts = {},
  --   cmd = { "Typr", "TyprStats" },
  -- },
}
