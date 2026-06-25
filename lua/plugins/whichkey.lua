return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    win = {
      border = "single",
      no_overlap = true,
      padding = { 1, 2 },
      title = false,
      title_pos = "center",
      zindex = 1000,
      bo = {},
      wo = {
        winblend = 15,
      },
    },
    layout = {
      width = { min = 20 },
      spacing = 6,
    },
    delay = 400,
    preset = "modern",
    -- base Util defaults (deprecated path handled in config below)
    defaults = {},
    spec = {
      -- folded-in Util base groups (user fragment below wins on conflicts)
      {
        mode = { "n", "x" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>dp", group = "profiler" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        -- better descriptions
        { "gx", desc = "Open with system app" },
      },
      {
        { "<leader>a", "", group = "A.I.", icon = { icon = " ", color = "azure" } },
        mode = { "n", "v" },
        { "<leader>d", group = "Debug", icon = { icon = " ", color = "red" } },
        { "<leader>v", group = "Spelunk", icon = { icon = " ", color = "red" } },
        { "<leader>c", group = "Code" },
        { "<leader>S", group = "TS Surround", icon = { icon = "󰐅 ", color = "azure" }, hidden = true },
        { "<leader>n", group = "Notif/Notes", icon = { icon = "󰵙 ", color = "yellow" }, hidden = false },
        { "<leader>m", group = "Markdown", icon = { icon = "󱦹 ", color = "azure" } },
        { "<leader>g", group = "Git", icon = { icon = "󰊤 ", color = "azure" } },
        { "<leader>G", group = "Git Hydra", icon = { icon = " ", color = "azure" } },
        { "<leader>gB", group = "Blame", icon = { icon = " ", color = "azure" } },
        { "<leader>gd", group = "Diff", icon = { icon = " ", color = "azure" } },
        { "<leader>q", group = "Quit/session" },
        { "<leader>s", group = "Search", icon = { icon = " ", color = "orange" } },
        { "<leader>u", group = "Toggle", icon = { icon = "󰙵 ", color = "azure" } },
        { "<leader>x", group = "Diagnostics", icon = { icon = "󰓙 ", color = "azure" } },
        { "<leader>mf", group = "Folds", icon = { icon = "" } },
        { "[", group = "Prev" },
        { "]", group = "Next" },
        { "g", group = "Goto" },
        { "gs", group = "Surround" },
        { "z", group = "Fold/Spelling" },
        {
          "<leader>b",
          group = "Buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "Windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        -- better descriptions
        -- valid colors are: `azure`, `blue`, `cyan`, `green`, `grey`, `orange`, `purple`, `red`, `yellow`
        { "gx", desc = "Open with system app" },
        { "<leader>e", desc = "File Tree", icon = { icon = "󰙅 ", color = "yellow" } },
        { "<leader>?", desc = "Buffer Keymaps", icon = { icon = "  ", color = "azure", hidden = true } },
        { "<leader><leader>", desc = "Lazygit", icon = { icon = " ", color = "azure" } },
        { "<leader>/", desc = "Grep Buffer", icon = { icon = "󰮗 ", color = "azure" } },

        { "<leader>gg", desc = "LazyGit", icon = { icon = "󰋣 ", color = "azure" } },
        { "<leader>gf", desc = "LazyGit File History", icon = { icon = "󰋣 ", color = "azure" } },
        { "<leader>gm", desc = "Commit Messsge", icon = { icon = " ", color = "azure" } },
        { "<leader>gG", desc = "Git Graph", icon = { icon = " ", color = "azure" } },
        { "<leader>gs", desc = "Search", icon = { icon = " ", color = "azure" } },
        { "<leader>gb", desc = "Branch", icon = { icon = " ", color = "azure" } },

        { "<leader>ax", desc = "Clear", icon = { icon = " ", color = "yellow" } },

        { "<localleader>d", group = "Database", icon = { icon = "󱦹 ", color = "yellow" }, mode = "x" },

        { "<leader>p", desc = "Void Paste", icon = { icon = "󱦹 ", color = "brown" }, mode = { "n", "x" } },

        { "<leader>1", hidden = true },
        { "<leader>2", hidden = true },
        { "<leader>3", hidden = true },
        { "<leader>4", hidden = true },
        { "<leader>5", hidden = true },
        { "<leader>6", hidden = true },
        { "<leader>7", hidden = true },
        { "<leader>8", hidden = true },
        { "<leader>9", hidden = true },
        { "<leader>z", hidden = true },
        -- { "<leader>q", hidden = true },
        { "<leader>.", hidden = true },
        { "<leader>D", hidden = true },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    if not vim.tbl_isempty(opts.defaults) then
      require("util").warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
      wk.register(opts.defaults)
    end
  end,
}
