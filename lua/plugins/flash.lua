return {
  "folke/flash.nvim",
  event = "VeryLazy",
  vscode = true,
  opts = {
    modes = {
      -- `f`, `F`, `t`, `T`, `;` and `,` motions
      char = {
        highlight = { backdrop = false },
      },
    },
  },
  keys = function()
    -- stylua: ignore
    return {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "󱐌 Search", },
      { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "󱐌 Treesitter Labels", },
      { "r", mode = "o", function() require("flash").remote() end, desc = "󱐌 Remote" },
      { "R", mode = { "n", "o", "x" }, function() require("flash").treesitter_search() end, desc = "󱐌 Treesitter Search", },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "󱐌 Toggle Flash Search", },
    }
  end,
}
