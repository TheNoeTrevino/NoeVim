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
      highlight RenderMarkdownH1Bg guibg=#9c3303 guifg=#fbf1c7 ctermbg=94 ctermfg=230
      highlight RenderMarkdownH2Bg guibg=#6d670d guifg=#ebdbb2 ctermbg=100 ctermfg=223
      highlight RenderMarkdownH3Bg guibg=#b57614 guifg=#282828 ctermbg=136 ctermfg=235
      highlight RenderMarkdownH4Bg guibg=#065966 guifg=#ebdbb2 ctermbg=23 ctermfg=223
      highlight RenderMarkdownH5Bg guibg=#7c365f guifg=#fbf1c7 ctermbg=96 ctermfg=230
      highlight RenderMarkdownH6Bg guibg=#3a6e50 guifg=#282828 ctermbg=65 ctermfg=235
    ]])
  end,
}
