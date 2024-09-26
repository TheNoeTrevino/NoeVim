return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    file_types = { "markdown", "norg", "rmd", "org" },
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
  },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  ft = { "markdown", "norg", "rmd", "org" },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    LazyVim.toggle.map("<leader>um", {
      name = "Render Markdown",
      get = function()
        return require("render-markdown.state").enabled
      end,
      set = function(enabled)
        local m = require("render-markdown")
        if enabled then
          m.enable()
        else
          m.disable()
        end
      end,
    })
    vim.cmd([[
      highlight RenderMarkdownH1Bg guibg=#502824 guifg=#ffead6 ctermbg=94 ctermfg=230  " Red
      highlight RenderMarkdownH3Bg guibg=#5a3d33 guifg=#e6d9be ctermbg=136 ctermfg=235 " Orange
      highlight RenderMarkdownH2Bg guibg=#37352f guifg=#e8e1c5 ctermbg=100 ctermfg=223 " Yellow
      highlight RenderMarkdownH4Bg guibg=#223b40 guifg=#d5e2e8 ctermbg=23 ctermfg=223  " Blue
      highlight RenderMarkdownH6Bg guibg=#22312d guifg=#d6eae1 ctermbg=65 ctermfg=235  " Green
      highlight RenderMarkdownH5Bg guibg=#362930 guifg=#f0d2e0 ctermbg=96 ctermfg=230  " Violet
    ]])
  end,
}
