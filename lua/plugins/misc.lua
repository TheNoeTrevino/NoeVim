return {
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },
  {
    "AndrewRadev/linediff.vim",
    cmd = "Linediff",
    event = "UIEnter",
    config = function()
      vim.keymap.set("x", "D", function()
        return vim.fn.mode() == "V" and ":Linediff<cr>" or "D"
      end, { noremap = true, expr = true })
    end,
  },
  { "nvim-mini/mini.doc", version = "*", opts = {}, lazy = true },
  {
    "AndrewRadev/linediff.vim",
    cmd = "Linediff",
    event = "UIEnter",
    opts = {
      multiwindow = true, -- Enable multiwindow support.
      max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = false,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = "─",
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
    {
      "2kabhishek/seeker.nvim",
      dependencies = { "folke/snacks.nvim" },
      cmd = { "Seeker" },
      keys = {
        { "<leader>sf", ":Seeker files<CR>", desc = "Seek Files" },
        -- { "<leader>ff", ":Seeker git_files<CR>", desc = "Seek Git Files" },
        { "<leader>sg", ":Seeker grep<CR>", desc = "Seek Grep" },
        -- { "<leader>fw", ":Seeker grep_word<CR>", desc = "Seek Grep Word" },
      },
      opts = {}, -- Required unless you call seeker.setup() manually, add your configs here
    },
  },
}
