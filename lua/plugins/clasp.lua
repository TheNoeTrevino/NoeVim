return {
  "xzbdmw/clasp.nvim",
  event = "VeryLazy",
  config = function()
    require("clasp").setup({
      pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]", ["<"] = ">" },
      keep_insert_mode = true,
      remove_pattern = nil,
    })
  end,
}
