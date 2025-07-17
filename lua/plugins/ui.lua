return {
  -- Extra Colors
  -- Uncomment below to choose a colorscheme
  { "loctvl842/monokai-pro.nvim", event = "VeryLazy" },
  { "catppuccin/nvim", name = "catppuccin", event = "VeryLazy" },
  { "tokyonight.nvim", event = "VeryLazy" },
  { "Mofiqul/vscode.nvim", event = "VeryLazy" },
  { "bluz71/vim-moonfly-colors", event = "VeryLazy" },
  { "bluz71/vim-nightfly-colors", event = "VeryLazy" },
  { "ellisonleao/gruvbox.nvim", event = "VeryLazy" },
  { "sainnhe/gruvbox-material", event = "VeryLazy" },
  { "projekt0n/github-nvim-theme", event = "VeryLazy" },
  { "scottmckendry/cyberdream.nvim", event = "VeryLazy" },
  { "tiagovla/tokyodark.nvim", event = "VeryLazy" },
  { "sainnhe/edge", event = "VeryLazy" },
  { "EdenEast/nightfox.nvim", event = "VeryLazy" },
  { "marko-cerovac/material.nvim", event = "VeryLazy" },
  { "sainnhe/sonokai", event = "VeryLazy" },
  { "Shatur/neovim-ayu", event = "VeryLazy" },
  { "ChristianChiarulli/nvcode-color-schemes.vim", event = "VeryLazy" },
  { "comfysage/evergarden", event = "VeryLazy" },
  { "nyoom-engineering/oxocarbon.nvim", event = "VeryLazy" },
  { "nvimdev/zephyr-nvim", event = "VeryLazy" },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    config = function()
      require("rose-pine").setup({
        variant = "auto", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },
        styles = {
          bold = true,
          italic = false,
          transparency = true,
        },
        highlight_groups = {
          -- String = { fg = "#FF0000" },
          -- Comment = { fg = "foam" },
          -- VertSplit = { fg = "muted", bg = "muted" },
        },
      })
    end,
  },
  {
    "https://gitlab.com/bartekjaszczak/distinct-nvim",

    event = "VeryLazy",
    config = function()
      require("distinct").setup({
        doc_comments_different_color = true, -- Use different colour for documentation comments
      })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    event = "VeryLazy",
    config = function()
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = false, -- enable undercurls
        commentStyle = { italic = false },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {
              ui = {
                -- bg = "#181616",
                bg = "#000001",
              },
            },
            lotus = {},
            dragon = {},
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          -- dark = "dragon", -- try "dragon" !
          -- light = "lotus",
        },
      })
    end,
  },
  { "xiyaowong/transparent.nvim", event = "UIEnter" },
  {
    "catgoose/nvim-colorizer.lua",
    event = "UIEnter",
    config = function()
      require("colorizer").setup({
        user_default_options = { mode = "virtualtext" },
      })
    end,
  },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },
  { "nvzone/volt", lazy = true },
  { "nvzone/timerly", cmd = "TimerlyToggle" },
  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
      timeout = 1,
      maxkeys = 5,
      position = "top-center",
    },
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
  {
    "aaron-p1/match-visual.nvim",
    config = function()
      require("match-visual").setup({
        -- minimum length of text to match
        min_length = 1,
        -- Visual group to use for highlighting
        -- You could also override the "VisualMatch" hl group to change the highlights.
        hl_group = "VisualMatch",
      })
    end,
  },
}
