return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    win = {
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
    delay = 100,
    preset = "modern",
    spec = {
      {
        { "<leader>a", "", group = "A.I.", icon = { icon = " ", color = "azure" } },
        mode = { "n", "v" },
        { "<Tab>", group = "Test" },
        { "<leader>x", group = "Debug", icon = { icon = " ", color = "red" } },
        { "<leader>r", group = "Reame", icon = { icon = "󱦹 ", color = "azure" } },
        { "<leader>c", group = "Code" },
        { "<leader>dt", group = "Trouble" },
        { "<leader>S", group = "TS Surround", icon = { icon = "󰐅 ", color = "azure" }, hidden = true },
        { "<leader>n", group = "Notification", icon = { icon = "󰵙 ", color = "yellow" }, hidden = false },
        { "<leader>m", group = "Markdown", icon = { icon = "󱦹 ", color = "azure" } },
        { "<leader>y", group = "Selection", icon = { icon = "󰒉 ", color = "azure" } },
        { "<leader>g", group = "Git", icon = { icon = "󰊤 ", color = "azure" } },
        { "<leader>gs", group = "Stage/Search", icon = { icon = "󰊤 " } },
        { "<leader>gsu", group = "Unstage", icon = { icon = " " } },
        { "<leader>gp", group = "Preview", icon = { icon = " " } },
        { "<leader>gr", group = "Reset", icon = { icon = " " } },
        { "<leader>gb", group = "Blame", icon = { icon = " ", color = "azure" } },
        { "<leader>gd", group = "Diff", icon = { icon = " ", color = "azure" } },
        { "<leader>q", group = "Quit/session" },
        { "<leader>s", group = "Search", icon = { icon = " ", color = "orange" } },
        { "<leader>u", group = "Toggle", icon = { icon = "󰙵 ", color = "azure" } },
        { "<leader>d", group = "Diagnostics", icon = { icon = "󰓙 ", color = "azure" } },
        { "<leader>mf", group = "Folds", icon = { icon = " " } },
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
        { "<leader>e", desc = " NeoTree", icon = { icon = "󰙅 ", color = "yellow" } },
        { "<leader>k", desc = " Peek Definition", icon = { icon = "󰈈 ", color = "red" } },
        { "<leader>l", desc = " Harpoon", icon = { icon = "󰧊 ", color = "azure" } },
        { "<leader>p", desc = " Yank History", icon = { icon = " ", color = "azure" } },
        { "<leader>0", desc = " Transparency", icon = { icon = " ", color = "azure" }, hidden = true },
        { "<leader>h", desc = " References", icon = { icon = " ", color = "purple" } },
        { "<leader>j", desc = " Jump to Definition", icon = { icon = "󰑮 ", color = "red" } },
        { "<leader>?", desc = " Buffer Keymaps", icon = { icon = "  ", color = "azure", hidden = true } },
        { "<leader><leader>", desc = "Search Buffers", icon = { icon = " ", color = "azure" } },
        { "<leader>/", desc = "Grep Buffer", icon = { icon = "󰮗 ", color = "azure" } },
        { "<leader>t", desc = "Terminal", icon = { icon = " ", color = "red" }, hidden = false },
        { "<leader>l", desc = "Jump Backwards", icon = { icon = " ", color = "orange" }, hidden = false },
        { "<leader>;", desc = "Jump Forwards", icon = { icon = " ", color = "orange" }, hidden = false },

        { "<leader>gg", desc = " LazyGit", icon = { icon = "󰋣 ", color = "azure" } },
        { "<leader>gl", desc = " LazyGit Log", icon = { icon = "󰋣 ", color = "azure" } },
        { "<leader>gf", desc = " LazyGit File History", icon = { icon = "󰋣 ", color = "azure" } },
        { "<leader>gm", desc = " Commit Messsge", icon = { icon = " ", color = "azure" } },
        { "<leader>gG", desc = " Git Graph", icon = { icon = " ", color = "azure" } },
        { "<leader>gL", hidden = true },
        { "<leader>gl", hidden = true },

        { "<leader>aa", desc = "Toggle ", icon = { icon = " ", color = "yellow" } },
        { "<leader>am", desc = "Select Model ", icon = { icon = " ", color = "yellow" } },
        { "<leader>ad", desc = "Diagnostic Help", icon = { icon = " ", color = "yellow" } },
        { "<leader>aq", desc = "Prompt Actions", icon = { icon = " ", color = "yellow" } },
        { "<leader>ap", desc = "Quick Chat", icon = { icon = " ", color = "yellow" } },
        { "<leader>ax", desc = "Clear", icon = { icon = " ", color = "yellow" } },

        { "<leader>1", hidden = true },
        { "<leader>2", hidden = true },
        { "<leader>3", hidden = true },
        { "<leader>4", hidden = true },
        { "<leader>5", hidden = true },
        { "<leader>z", hidden = true },
        { "<leader>p", hidden = true },
        { "<leader>y", hidden = true },
        { "<leader>b", hidden = true },
        { "<leader>i", hidden = true },
        { "<leader>o", hidden = true },
        { "<leader>?", hidden = true },
        { "<leader>f", hidden = true },
      },
    },
  },
  keys = {
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
      LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
      wk.register(opts.defaults)
    end
  end,
}
