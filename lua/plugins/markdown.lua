return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "Avante", "AvanteInput", "copilot-chat" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    -- NOTE: you might have to uninstall and reinstall this for it to work
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "norg", "rmd", "org", "Avante", "AvanteInput", "copilot-chat" },
        code = {
          enabled = true,
          render_modes = false,
          sign = true,
          conceal_delimiters = true,
          language = true,
          position = "left",
          language_icon = true,
          language_name = true,
          language_info = true,
          language_pad = 0,
          disable_background = { "diff" },
          width = "block",
          left_pad = 1,
          right_pad = 4,
          left_margin = 0,
          min_width = 0,
          border = "thick",
          language_border = " ",
          language_left = "██", --
          language_right = "█",
          above = "▄",
          below = "▀",
          inline = true,
          inline_left = "█",
          inline_right = "█",
          inline_pad = 0,
          highlight = "RenderMarkdownCode",
          highlight_info = "RenderMarkdownCodeInfo",
          highlight_language = nil,
          highlight_border = "RenderMarkdownCodeBorder",
          highlight_fallback = "RenderMarkdownCodeFallback",
          highlight_inline = "RenderMarkdownCodeInline",
          style = "full",
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
          heading = {
            sign = false,
            icons = { "󰎦 ", "󰎩 ", "󰎬 ", "󰎮 ", "󰎰 ", "󰎵 " },
          },
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
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
  },
  {
    "sotte/presenting.nvim",
    ft = "markdown",
    opts = function()
      require("presenting").setup({
        keymaps = {
          -- These are local mappings for the open slide buffer.
          -- Disable existing keymaps by setting them to `nil`.
          -- Add your own keymaps as you desire.
          -- stylua: ignore start
          ["n"] = function() Presenting.next() end,
          ["p"] = function() Presenting.prev() end,
          ["q"] = function() Presenting.quit() end,
          ["f"] = function() Presenting.first() end,
          ["l"] = function() Presenting.last() end,
          ["<CR>"] = function() Presenting.next() end,
          ["<BS>"] = function() Presenting.prev() end,
          -- stylua: ignore end
        },
      })
    end,
  },
}
