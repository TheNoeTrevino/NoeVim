return {
  "TheNoeTrevino/haunt.nvim",
  branch = "nightly",
  -- dir = "~/projects/haunt/haunt.nvim/",
  ---@class HauntConfig
  opts = {
    picker = "auto",
    sign = "󱙝",
    sign_hl = "DiagnosticInfo",
    virt_text_hl = "HauntAnnotation",
    annotation_prefix = " 󰆉 ",
    line_hl = nil,
    virt_text_pos = "eol",
    data_dir = nil,
    picker_keys = {
      delete = { key = "d", mode = { "n" } },
      edit_annotation = { key = "a", mode = { "n" } },
    },
  },
  -- recommended keymaps, with a helpful prefix alias
  init = function()
    local map = vim.keymap.set
    local prefix = "<leader>h"

    -- annotations
    map("n", prefix .. "a", function()
      require("haunt.api").annotate()
    end, { desc = "Annotate" })

    map("n", prefix .. "t", function()
      require("haunt.api").toggle_annotation()
    end, { desc = "Toggle annotation" })

    map("n", prefix .. "T", function()
      require("haunt.api").toggle_all_lines()
    end, { desc = "Toggle all annotations" })

    map("n", prefix .. "d", function()
      require("haunt.api").delete()
    end, { desc = "Delete bookmark" })

    map("n", prefix .. "C", function()
      require("haunt.api").clear_all()
    end, { desc = "Delete all bookmarks" })

    -- move
    map("n", prefix .. "p", function()
      require("haunt.api").prev()
    end, { desc = "Previous bookmark" })

    map("n", prefix .. "n", function()
      require("haunt.api").next()
    end, { desc = "Next bookmark" })

    -- picker
    map("n", prefix .. "l", function()
      require("haunt.picker").show()
    end, { desc = "Show Picker" })

    -- yank
    map("n", prefix .. "y", function()
      require("haunt.api").yank_locations({ current_buffer = true })
    end, { desc = "Show Picker" })

    map("n", prefix .. "Y", function()
      require("haunt.api").yank_locations()
    end, { desc = "Show Picker" })
  end,
}
