return {
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {

    -- Only in normal mode 
    -- { "s", mode = {"x", "o"}, false },
    { "S", mode = {"x", "o"}, false },
    { "r", mode = {"x", "o"}, false },
    { "R", mode = {"x", "o"}, false },
    { "<c-s>", mode = {"c"}, false },
  },
}
