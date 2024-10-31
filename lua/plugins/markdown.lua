return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {
      paragraph = {
        enabled = true,
      },
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
      },
      file_types = { "markdown", "norg", "rmd", "org" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = { "󰎦 ", "󰎩 ", "󰎬 ", "󰎮 ", "󰎰 ", "󰎵 " },
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    config = function(_, opts)
      require("render-markdown").setup(opts)
      LazyVim.toggle.map("<leader>um", {
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
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
          MkdnTableNextCell = { "i", "<Tab>" },
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
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        backdrop = 0.8, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        width = 110, -- width of the Zen window
        height = 1, -- height of the Zen window
        options = {
          -- signcolumn = "no", -- disable signcolumn
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          laststatus = 0, -- turn off the statusline in zen mode
        },
        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = true }, -- disables git signs
        tmux = { enabled = false }, -- disables the tmux statusline
        todo = { enabled = false }, -- if set to "true", todo-comments.nvim highlights will be disabled
        kitty = {
          enabled = true,
          font = "+1", -- font size increment
        },
      },
      on_open = function(win) end,
      on_close = function() end,
    },
  },
  { "TheNoeTrevino/mistake.nvim", event = "VeryLazy" },
}
