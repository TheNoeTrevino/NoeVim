return {
  -- Util
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "ThePrimeagen/vim-be-good", event = "VeryLazy" },
  { "tummetott/unimpaired.nvim", event = "VeryLazy" },
  { "knubie/vim-kitty-navigator", event = "VeryLazy" },
  { "stevearc/oil.nvim", event = "VeryLazy", opts = {} },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    config = function()
      require("quicker").setup({
        -- Local options to set for quickfix
        opts = {
          buflisted = false,
          number = false,
          relativenumber = false,
          signcolumn = "auto",
          winfixheight = true,
          wrap = false,
        },
        on_qf = function(bufnr) end,
        edit = {
          -- Enable editing the quickfix like a normal buffer
          enabled = true,
          -- Set to true to write buffers after applying edits.
          -- Set to "unmodified" to only write unmodified buffers.
          autosave = "unmodified",
        },
        -- Keep the cursor to the right of the filename and lnum columns
        constrain_cursor = true,
        highlight = {
          -- Use treesitter highlighting
          treesitter = true,
          -- Use LSP semantic token highlighting
          lsp = true,
          -- Load the referenced buffers to apply more accurate highlights (may be slow)
          load_buffers = true,
        },
        -- Map of quickfix item type to icon
        type_icons = {
          E = "󰅚 ",
          W = "󰀪 ",
          I = " ",
          N = " ",
          H = " ",
        },
        -- Border characters
        borders = {
          vert = "┃  ",
          -- Strong headers separate results from different files
          strong_header = "━",
          strong_cross = "╋",
          strong_end = "┫",
          -- Soft headers separate results within the same file
          soft_header = "╌",
          soft_cross = "╂",
          soft_end = "┨",
        },
        -- Trim the leading whitespace from results
        trim_leading_whitespace = true,
        -- Maximum width of the filename column
        max_filename_width = function()
          return math.floor(math.min(95, vim.o.columns / 2))
        end,
        -- How far the header should extend to the right
        header_length = function(type, start_col)
          return vim.o.columns - start_col
        end,
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "roobert/surround-ui.nvim",
    event = "VeryLazy",
    dependencies = {
      "kylechui/nvim-surround",
      "folke/which-key.nvim",
    },
    config = function()
      require("surround-ui").setup({
        root_key = "S",
      })
    end,
  },
}
