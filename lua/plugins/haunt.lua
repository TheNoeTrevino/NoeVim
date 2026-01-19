return {
  dir = "~/projects/haunt.nvim/",

  config = function()
    require("haunt").setup({
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
    })
  end,
  init = function()
    local map = vim.keymap.set
    map("n", "mt", function()
      require("haunt.api").toggle_annotation()
    end, { desc = "Toggle annotation" })

    map("n", "mT", function()
      require("haunt.api").toggle_all_lines()
    end, { desc = "Toggle all annotations" })

    map("n", "md", function()
      require("haunt.api").delete()
    end, { desc = "Delete bookmark" })

    map("n", "mn", function()
      require("haunt.api").next()
    end, { desc = "Next bookmark" })

    map("n", "ma", function()
      require("haunt.api").annotate()
    end, { desc = "Next bookmark" })

    map("n", "ml", function()
      require("haunt.picker").show()
    end, { desc = "Next bookmark" })

    -- move
    map("n", "mp", function()
      require("haunt.api").prev()
    end, { desc = "Previous bookmark" })

    map("n", "ma", function()
      require("haunt.api").annotate()
    end, { desc = "Annotate bookmark" })

    -- clear
    map("n", "mC", function()
      require("haunt.api").clear_all()
    end, { desc = "Clear all bookmarks" })
  end,
}
