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
    map("n", "ht", function()
      require("haunt.api").toggle()
    end, { desc = "Toggle bookmark" })

    map("n", "hd", function()
      require("haunt.api").delete()
    end, { desc = "Delete bookmark" })

    map("n", "hn", function()
      require("haunt.api").next()
    end, { desc = "Next bookmark" })

    map("n", "ha", function()
      require("haunt.api").annotate()
    end, { desc = "Next bookmark" })

    map("n", "hl", function()
      require("haunt.picker").show()
    end, { desc = "Next bookmark" })

    -- move
    map("n", "hp", function()
      require("haunt.api").prev()
    end, { desc = "Previous bookmark" })

    map("n", "ha", function()
      require("haunt.api").annotate()
    end, { desc = "Annotate bookmark" })

    -- clear
    map("n", "hc", function()
      require("haunt.api").clear()
    end, { desc = "Clear bookmarks in file" })

    map("n", "hC", function()
      require("haunt.api").clear_all()
    end, { desc = "Clear all bookmarks" })
  end,
}
