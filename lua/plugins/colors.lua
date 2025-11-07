return {
  {
    "pocco81/high-str.nvim",
    event = "VeryLazy",
    opts = {
      verbosity = 0,
      saving_path = "/tmp/highstr/",
      highlight_colors = {
        color_0 = { "#502824 ", "smart" },
        color_1 = { "#bd9b3e", "smart" },
        color_2 = { "#5a3d33 ", "smart" },
        color_3 = { "#37352f ", "smart" },
        color_4 = { "#223b40 ", "smart" },
        color_5 = { "#22312d ", "smart" },
        color_6 = { "#362930 ", "smart" },
        color_7 = { "#0000FF", "smart" },
        color_8 = { "#FFC0CB", "smart" },
        color_9 = { "#FFF9E3", "smart" },
      },
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    ft = { "css", "scss", "html", "lua", "ts" },
    config = function()
      require("colorizer").setup({
        user_default_options = { mode = "virtualtext" },
      })
    end,
  },
}
