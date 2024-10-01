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
  { "xiyaowong/transparent.nvim" },
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
  ---@diagnostic disable: missing-fields
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    config = function()
      -- default config
      require("image").setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            filetypes = { "markdown" }, -- markdown extensions (ie. quarto) can go here
          },
          html = {
            enabled = false,
          },
          css = {
            enabled = false,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
      })
    end,
  },
  {
    "anuvyklack/windows.nvim",
    event = "VeryLazy",
    dependencies = "anuvyklack/middleclass",
    config = function()
      require("windows").setup()
    end,
  },
}
