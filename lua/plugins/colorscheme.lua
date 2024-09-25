return {
  -- Extra Colors
  { "zenbones-theme/zenbones.nvim", dependencies = "rktjmp/lush.nvim", event = "VeryLazy" },
  { "rose-pine/neovim", name = "rosepine", event = "VeryLazy" },
  { "catppuccin/nvim", name = "catppuccin", event = "VeryLazy" },
  { "rebelot/kanagawa.nvim", event = "VeryLazy" },
  { "tokyonight.nvim", event = "VeryLazy" },
  { "Mofiqul/vscode.nvim", event = "VeryLazy" },
  { "bluz71/vim-moonfly-colors", event = "VeryLazy" },
  { "bluz71/vim-nightfly-colors", event = "VeryLazy" },
  { "morhetz/gruvbox", event = "VeryLazy" },
  { "sainnhe/gruvbox-material", event = "VeryLazy" },
  { "xiyaowong/transparent.nvim", cmd = "TransparentToggle" },
  { "projekt0n/github-nvim-theme", event = "VeryLazy" },
  { "scottmckendry/cyberdream.nvim", event = "VeryLazy" },
  { "tiagovla/tokyodark.nvim", event = "VeryLazy" },
  { "sainnhe/edge", event = "VeryLazy" },
  { "EdenEast/nightfox.nvim", event = "VeryLazy" },
  { "marko-cerovac/material.nvim", event = "VeryLazy" },
  { "sainnhe/sonokai", event = "VeryLazy" },
  { "Shatur/neovim-ayu", event = "VeryLazy" },
  {
    "rose-pine/neovim",
    lazy = true,
    config = function()
      require("rose-pine").setup({
        styles = {
          bold = true,
          italic = false,
          transparency = false,
        },
      })
    end,
  },
}
