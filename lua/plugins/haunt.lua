local haunt = require("haunt.api")
local haunt_picker = require("haunt.picker")
return {
  dir = "~/projects/haunt.nvim/",
  opts = {
    picker_keys = {
      delete = {
        key = "d",
        mode = { "n" },
      },
      edit_annotation = {
        key = "a",
        mode = { "n" },
      },
    },
  },
  init = function()
    local map = vim.keymap.set
    map("n", "mt", function()
      haunt.toggle_annotation()
    end, { desc = "Toggle annotation" })

    map("n", "mT", function()
      haunt.toggle_all_lines()
    end, { desc = "Toggle all annotations" })

    map("n", "md", function()
      haunt.delete()
    end, { desc = "Delete bookmark" })

    map("n", "mn", function()
      haunt.next()
    end, { desc = "Next bookmark" })

    map("n", "ma", function()
      haunt.annotate()
    end, { desc = "Next bookmark" })

    map("n", "ml", function()
      haunt_picker.show()
    end, { desc = "Next bookmark" })

    -- move
    map("n", "mp", function()
      haunt.prev()
    end, { desc = "Previous bookmark" })

    map("n", "ma", function()
      haunt.annotate()
    end, { desc = "Annotate bookmark" })

    -- clear
    map("n", "mC", function()
      haunt.clear_all()
    end, { desc = "Clear all bookmarks" })
  end,
}
