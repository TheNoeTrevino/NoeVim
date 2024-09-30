return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
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
    ft = { "markdown", "norg", "rmd", "org" },
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
        -- mappings = {
        --   MkdnEnter = false,
        --   MkdnTab = false,
        --   MkdnSTab = false,
        --   MkdnNextLink = { "n", "<Tab>" },
        --   MkdnPrevLink = { "n", "<S-Tab>" },
        --   MkdnNextHeading = { "n", "]]" },
        --   MkdnPrevHeading = { "n", "[[" },
        --   MkdnGoBack = { "n", "<BS>" },
        --   MkdnGoForward = { "n", "<Del>" },
        --   MkdnCreateLink = false, -- see MkdnEnter
        --   MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>p" }, -- see MkdnEnter
        --   MkdnFollowLink = false, -- see MkdnEnter
        --   MkdnDestroyLink = { "n", "<M-CR>" },
        --   MkdnTagSpan = { "v", "<M-CR>" },
        --   MkdnMoveSource = { "n", "<F2>" },
        --   MkdnYankAnchorLink = { "n", "yaa" },
        --   MkdnYankFileAnchorLink = { "n", "yfa" },
        --   MkdnIncreaseHeading = { "n", "+" },
        --   MkdnDecreaseHeading = { "n", "-" },
        --   MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
        --   MkdnNewListItem = false,
        --   MkdnNewListItemBelowInsert = { "n", "o" },
        --   MkdnNewListItemAboveInsert = { "n", "O" },
        --   MkdnExtendList = false,
        --   MkdnUpdateNumbering = { "n", "<leader>nn" },
        --   MkdnTableNextCell = { "i", "<Tab>" },
        --   MkdnTablePrevCell = { "i", "<S-Tab>" },
        --   MkdnTableNextRow = false,
        --   MkdnTablePrevRow = { "i", "<M-CR>" },
        --   MkdnTableNewRowBelow = { "n", "<leader>ir" },
        --   MkdnTableNewRowAbove = { "n", "<leader>iR" },
        --   MkdnTableNewColAfter = { "n", "<leader>ic" },
        --   MkdnTableNewColBefore = { "n", "<leader>iC" },
        --   MkdnFoldSection = { "n", "<leader>f" },
        --   MkdnUnfoldSection = { "n", "<leader>F" },
        -- },
      })
      vim.keymap.set("n", "<CR>", "<cmd>Lspsaga goto_definition<CR>")
    end,
  },
}
