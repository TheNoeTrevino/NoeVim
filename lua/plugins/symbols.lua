local this = "hlelo"
return {
  "bassamsdata/namu.nvim",
  opts = {
    -- Enable symbols navigator which is the default
    namu_symbols = {
      enable = true,
      ---@type NamuConfig
      options = {
        -- This is a preset that let's set window without really get into the hassle of tuning window options
        -- top10 meaning top 10% of the window
        actions = {
          close_on_yank = false, -- Whether to close picker after yanking
          close_on_delete = true, -- Whether to close picker after deleting
        },
        movement = { -- Support multiple keys
          next = { "C-n", "<C-k>", "<DOWN>" },
          previous = { "<C-p>", "<C-l>", "<UP>" },
          close = { "<ESC>" }, -- "<C-c>" can be added as well
          select = { "<CR>" },
          delete_word = {}, -- it can assign "<C-w>"
          clear_line = {}, -- it can be "<C-u>"
        },
        custom_keymaps = {
          yank = {
            keys = { "<C-y>" },
            desc = "Yank symbol text",
          },
          delete = {
            keys = { "<C-d>" },
            desc = "Delete symbol text",
          },
          vertical_split = {
            keys = { "<C-v>" },
            desc = "Open in vertical split",
          },
          horizontal_split = {
            keys = { "<C-h>" },
            desc = "Open in horizontal split",
          },
          codecompanion = {
            keys = "<C-o>",
            desc = "Add symbol to CodeCompanion",
          },
          avante = {
            keys = "<C-t>",
            desc = "Add symbol to Avante",
          },
        },
        icon = "󱠦", -- 󱠦 -  -  -- 󰚟
        -- #525251
        highlight = "NamuPreview",
        highlights = {
          parent = "NamuParent",
          nested = "NamuNested",
          style = "NamuStyle",
        },
        multiselect = {
          keymaps = {
            clear_all = false,
          },
        },
      },
    },
  },
  -- === Suggested Keymaps: ===
  vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
    desc = "Jump to LSP symbol",
    silent = true,
  }),
  vim.keymap.set("n", "<leader>sw", ":Namu workspace<cr>", {
    desc = "LSP Symbols - Workspace",
    silent = true,
  }),
}
