return {
  -- Extra Colors
  { "zenbones-theme/zenbones.nvim", dependencies = "rktjmp/lush.nvim", event = "VeryLazy" },
  { "rose-pine/neovim", name = "rosepine", event = "VeryLazy" },
  { "catppuccin/nvim", name = "catppuccin", event = "VeryLazy" },
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
  { "ChristianChiarulli/nvcode-color-schemes.vim", event = "VeryLazy" },
  { "comfysage/evergarden", event = "VeryLazy" },
  { "uloco/bluloco.nvim", event = "VeryLazy" },
  { "nyoom-engineering/oxocarbon.nvim", event = "VeryLazy" },
  { "nvimdev/zephyr-nvim", event = "VeryLazy" },
  {
    "nvim-zh/colorful-winsep.nvim",
    config = function()
      require("colorful-winsep").setup({
        -- highlight for Window separator
        hi = {
          bg = "#16161E",
          fg = "#1F3442",
        },
        -- This plugin will not be activated for filetype in the following table.
        no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
        -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
        symbols = { "━", "┃", "┏", "┓", "┗", "┛" },

        -- #70: https://github.com/nvim-zh/colorful-winsep.nvim/discussions/70
        only_line_seq = true,
        -- Smooth moving switch
        smooth = false,
        exponential_smoothing = true,
      })
    end,
    event = { "WinLeave" },
  },
  {
    "sontungexpt/witch",
    priority = 1000,
    lazy = true,
    config = function(_, opts)
      require("witch").setup({
        theme = {
          enabled = true,
          on_highlight = function(style, colors, highlight)
            if style == "dark" then
              colors.bg = "#181616"
            end
          end,
        },
        dim_inactive = {
          enabled = true,
          level = 0.90,
        },
      })
    end,
  },
  {
    "ray-x/aurora",
    event = "VeryLazy",
    init = function()
      vim.g.aurora_italic = 0
      vim.g.aurora_bold = 1
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
          dark = "dragon", -- try "dragon" !
          light = "lotus",
        },
      })
      if vim.g.colors_name == "kanagawa-wave" then
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ff5f87", bg = "NONE", bold = true }) -- Customize as needed
      end
    end,
  },
  {
    "0xstepit/flow.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("flow").setup({
        dark_theme = true, -- Set the theme with dark background.
        high_contrast = false, -- Make the dark background darker or the light background lighter.
        transparent = false, -- Set transparent background.
        fluo_color = "pink", -- Color used as fluo. Available values are pink, yellow, orange, or green.
        mode = "bright", -- Mode of the colors. Available values are: dark, bright, desaturate, or base.
        aggressive_spell = false, -- Use colors for spell check.
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
  { "jim-at-jibba/ariake.nvim", event = "VeryLazy" },

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
  {
    "miversen33/sunglasses.nvim",
    -- event = "VeryLazy",
    -- config = true,
    -- cmd = "SunglassesEnableToggle",
    config = function()
      require("sunglasses").setup({
        filter_percent = 0.08,
        filter_type = "SHADE",
        excluded_highlights = {
          "WinSeparator",
          "GitSignsAdd",
          "GitSignsChange",
          "GitSignsCurrentLineBlame",

          { "lualine_.*", glob = true },
        },
      })
    end,
  },
}
