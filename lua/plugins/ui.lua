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
  { "xiyaowong/transparent.nvim", event = "UIEnter" },
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
        dim_inactive_windows = true,
        extend_background_behind_borders = true,
        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },
        styles = {
          bold = false,
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
    "nvim-zh/colorful-winsep.nvim",
    cmd = "LoadColorfulWinsep",
    -- event = "UIEnter",
    config = function()
      require("colorful-winsep").setup({
        -- highlight for Window separator
        hi = {
          -- bg = "#16161E",
          -- fg = "#1F3442",
        },
        -- Smooth moving switch
        smooth = false,
        exponential_smoothing = true,
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
        keywordStyle = { italic = false },
        statementStyle = { bold = false },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {
              ui = {
                bg = "#181616",
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
      if vim.g.colors_name == "kanagawa-wave" then
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ff5f87", bg = "NONE", bold = true }) -- Customize as needed
      end

      local kanagawa_themes = { "kanagawa", "kanagawa-wave", "kanagawa-lotus", "kanagawa-dragon" }
      if vim.tbl_contains(kanagawa_themes, vim.g.colors_name) then
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ff5f87", bg = "NONE", bold = true }) -- Customize as needed
      end
    end,
  },
  {
    "3rd/image.nvim",
    event = "LazyFile",
    config = function()
      require("image").setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
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
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
      })
    end,
  },
  {
    "anuvyklack/windows.nvim",
    event = "VeryLazy",
    dependencies = "anuvyklack/middleclass",
    config = function()
      require("windows").setup(
        {
          autowidth = { --		       |windows.autowidth|
            enable = false,
            winwidth = 5, --		        |windows.winwidth|
            filetype = { --	      |windows.autowidth.filetype|
              help = 2,
            },
          },
          ignore = { --			  |windows.ignore|
            buftype = { "quickfix" },
            filetype = { "NvimTree", "neo-tree", "undotree", "gundo" },
          },
          animation = {
            enable = true,
            duration = 300,
            fps = 30,
            easing = "in_out_sine",
          },
        }
        ----
      )
    end,
  },
  {
    "miversen33/sunglasses.nvim",
    cmd = "SunglassesEnableToggle",
    -- event = "UIEnter",
    config = function()
      require("sunglasses").setup({
        filter_percent = 0.08,
        filter_type = "SHADE",
        excluded_highlights = {
          -- "WinSeparator",
          "GitSignsAdd",
          "GitSignsChange",
          "GitSignsCurrentLineBlame",

          { "lualine_.*", glob = true },
        },
      })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "UIEnter",
    config = function()
      require("colorizer").setup({
        user_default_options = { mode = "virtualtext" },
      })
    end,
  },
}
