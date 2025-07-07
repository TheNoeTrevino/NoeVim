return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "Avante", "AvanteInput" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "norg", "rmd", "org", "Avante", "AvanteInput" },
        checkbox = {
          enabled = true,
          position = "inline",
          unchecked = {
            icon = "󰄱 ",
            highlight = "RenderMarkdownUnchecked",
            scope_highlight = nil,
          },
          checked = {
            icon = "󰱒 ",
            highlight = "RenderMarkdownChecked",
            scope_highlight = nil,
          },
          custom = {
            todo = { raw = "[-]", rendered = "󰅐 ", highlight = "RenderMarkdownTodo" },
          },
          code = {
            enabled = false,
            render_modes = true,
            sign = true,
            style = "none",
          },
          heading = {
            sign = false,
            icons = { "󰎦 ", "󰎩 ", "󰎬 ", "󰎮 ", "󰎰 ", "󰎵 " },
          },
        },
        code = {
          -- Turn on / off code block & inline code rendering.
          enabled = true,
          -- Additional modes to render code blocks.
          render_modes = true,
          -- Turn on / off any sign column related rendering.
          sign = true,
          -- Determines how code blocks & inline code are rendered.
          -- | none     | disables all rendering                                                    |
          -- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
          -- | language | language icon to sign column if enabled and icon + name above code blocks |
          -- | full     | normal + language                                                         |
          style = "full",
          -- Determines where language icon is rendered.
          -- | right | right side of code block |
          -- | left  | left side of code block  |
          position = "left",
          -- Amount of padding to add around the language.
          -- If a float < 1 is provided it is treated as a percentage of available window space.
          language_pad = 0,
          -- Whether to include the language icon above code blocks.
          language_icon = true,
          -- Whether to include the language name above code blocks.
          language_name = true,
          -- Whether to include the language info above code blocks.
          language_info = true,
          -- A list of language names for which background highlighting will be disabled.
          -- Likely because that language has background highlights itself.
          -- Use a boolean to make behavior apply to all languages.
          -- Borders above & below blocks will continue to be rendered.
          disable_background = { "diff" },
          -- Width of the code block background.
          -- | block | width of the code block  |
          -- | full  | full width of the window |
          width = "full",
          -- Amount of margin to add to the left of code blocks.
          -- If a float < 1 is provided it is treated as a percentage of available window space.
          -- Margin available space is computed after accounting for padding.
          left_margin = 0,
          -- Amount of padding to add to the left of code blocks.
          -- If a float < 1 is provided it is treated as a percentage of available window space.
          left_pad = 0,
          -- Amount of padding to add to the right of code blocks when width is 'block'.
          -- If a float < 1 is provided it is treated as a percentage of available window space.
          right_pad = 0,
          -- Minimum width to use for code blocks when width is 'block'.
          min_width = 0,
          -- Determines how the top / bottom of code block are rendered.
          -- | none  | do not render a border                               |
          -- | thick | use the same highlight as the code body              |
          -- | thin  | when lines are empty overlay the above & below icons |
          -- | hide  | conceal lines unless language name or icon is added  |
          border = "thick",
          -- Used above code blocks to fill remaining space around language.
          language_border = "█",
          -- Added to the left of language.
          language_left = "",
          -- Added to the right of language.
          language_right = "",
          -- Used above code blocks for thin border.
          above = "▄",
          -- Used below code blocks for thin border.
          below = "▀",
          -- Icon to add to the left of inline code.
          inline_left = "",
          -- Icon to add to the right of inline code.
          inline_right = "",
          -- Padding to add to the left & right of inline code.
          inline_pad = 0,
          -- Highlight for code blocks.
          highlight = "RenderMarkdownCode",
          -- Highlight for code info section, after the language.
          highlight_info = "RenderMarkdownCodeInfo",
          -- Highlight for language, overrides icon provider value.
          highlight_language = nil,
          -- Highlight for border, use false to add no highlight.
          highlight_border = "RenderMarkdownCodeBorder",
          -- Highlight for language, used if icon provider does not have a value.
          highlight_fallback = "RenderMarkdownCodeFallback",
          -- Highlight for inline code.
          highlight_inline = "RenderMarkdownCodeInline",
        },
      })
    end,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
    config = function()
      require("mkdnflow").setup({
        foldtext = {
          object_count_icon_set = "nerdfont", -- Use/fall back on the nerdfont icon set
          object_count_opts = function()
            local opts = {
              link = false, -- Prevent links from being counted
              blockquote = { -- Count block quotes (these aren't counted by default)
                icon = " ",
                count_method = {
                  pattern = { "^>.+$" },
                  tally = "blocks",
                },
              },
              fncblk = {
                -- Override the icon for fenced code blocks with 
                icon = " ",
              },
            }
            return opts
          end,
          line_count = true, -- Prevent lines from being counted
          word_count = true, -- Count the words in the section
          -- fill_chars = {
          --   left_edge = "╾─🖿 ─",
          --   right_edge = "──╼",
          --   item_separator = " · ",
          --   section_separator = " // ",
          --   left_inside = " ┝",
          --   right_inside = "┥ ",
          --   middle = "─",
          -- },
        },

        mappings = {
          MkdnEnter = { { "n", "v" }, "<CR>" },
          MkdnTab = false,
          MkdnSTab = false,
          MkdnNextLink = { "n", "<C-n>" },
          MkdnPrevLink = { "n", "<C-p>" },
          MkdnNextHeading = { "n", "]]" },
          MkdnPrevHeading = { "n", "[[" },
          MkdnGoBack = { "n", "<BS>" },
          MkdnGoForward = { "n", "<Del>" },
          MkdnCreateLink = false, -- see MkdnEnter
          MkdnCreateLinkFromClipboard = false, -- see MkdnEnter
          MkdnFollowLink = false, -- see MkdnEnter
          MkdnDestroyLink = { "n", "<S-CR>" },
          MkdnTagSpan = { "v", "<S-CR>" },
          MkdnMoveSource = { "n", "<F2>" },
          MkdnYankAnchorLink = { "n", "yaa" },
          MkdnYankFileAnchorLink = { "n", "yfa" },
          MkdnIncreaseHeading = { "n", "+" },
          MkdnDecreaseHeading = { "n", "-" },
          MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
          MkdnNewListItem = false,
          MkdnNewListItemBelowInsert = { "n", "o" },
          MkdnNewListItemAboveInsert = { "n", "O" },
          MkdnExtendList = false,
          MkdnUpdateNumbering = { "n", "<leader>nn" },
          MkdnTableNextCell = { "i", "<C-N>" },
          MkdnTablePrevCell = { "i", "<S-Tab>" },
          MkdnTableNextRow = false,
          MkdnTablePrevRow = { "i", "<S-CR>" },
          MkdnTableNewRowBelow = { "n", "<leader>ir" },
          MkdnTableNewRowAbove = { "n", "<leader>iR" },
          MkdnTableNewColAfter = { "n", "<leader>ic" },
          MkdnTableNewColBefore = { "n", "<leader>iC" },
          MkdnFoldSection = { "n", "zc" },
          MkdnUnfoldSection = { "n", "zo" },
        },
      })
    end,
  },
  { "bullets-vim/bullets.vim", ft = { "markdown", "norg", "rmd", "org" } },
}
