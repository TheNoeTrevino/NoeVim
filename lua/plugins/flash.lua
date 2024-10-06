return {
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  opts = {},
  keys = function()
    -- stylua: ignore
    return {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "󱐌 Flash", },
      { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "󱐌 Flash Treesitter", },
      { "r", mode = "o", function() require("flash").remote() end, desc = "󱐌 Remote Flash" },
      { "R", mode = { "n", "o", "x" }, function() require("flash").treesitter_search() end, desc = "󱐌 Treesitter Search", },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "󱐌 Toggle Flash Search", },
    }
  end,
}
