return {
  "cbochs/portal.nvim",
  event = "VeryLazy",
  config = function()
    require("portal").setup({
      ---@type string[]
      labels = { "j", "k", "l", ";" },

      window_options = {
        relative = "cursor",
        width = 80,
        height = 6,
        col = 2,
        focusable = false,
        border = "rounded",
        noautocmd = true,
      },
    })
  end,
}
