return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    delay = 20,
    preset = "modern",
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>a", "", group = "A.I.", icon = { icon = " " } },
        { "<Tab>", group = "Tabs" },
        { "<leader>x", group = "Debug", icon = { icon = " " } },
        { "<leader>r", group = "Reame", icon = { icon = "󱦹 " } },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>n", group = "Notification", icon = { icon = "󰵙 " } },
        { "<leader>m", group = "Markdown", icon = { icon = "󱦹 " } },
        { "<leader>y", group = "Selection", icon = { icon = "󰒉 " } },
        { "<leader>g", group = "Git", icon = { icon = "󰊤 " } },
        { "<leader>gs", group = "Stage/Search", icon = { icon = "󰊤 " } },
        { "<leader>gsu", group = "Unstage", icon = { icon = " " } },
        { "<leader>gp", group = "Preview", icon = { icon = " " } },
        { "<leader>gr", group = "Reset", icon = { icon = " " } },
        { "<leader>gb", group = "Blame", icon = { icon = " " } },
        { "<leader>gd", group = "Diff", icon = { icon = " " } },
        { "<leader>q", group = "Quit/session" },
        { "<leader>s", group = "Search", icon = { icon = " " } },
        { "<leader>u", group = "Ui", icon = { icon = "󰙵 " } },
        { "<leader>d", group = "Diagnostics", icon = { icon = "󰓙 " } },
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
        { "<leader>L", desc = " Lazy", icon = { icon = "󰒲 ", color = "purple" } },
        { "<leader>e", desc = " NeoTree", icon = { icon = " ", color = "yellow" } },
        { "<leader>o", desc = " Jumplist", icon = { icon = " ", color = "yellow" } },
        { "<leader>i", desc = " Changelist", icon = { icon = " ", color = "yellow" } },
        { "<leader>k", desc = " Peek Definition", icon = { icon = "󰈈 ", color = "yellow" } },
        { "<leader>l", desc = " Outline", icon = { icon = "󰧊 ", color = "yellow" } },
        { "<leader>0", desc = " Transparency", icon = { icon = " ", color = "purple" } },
        { "<leader>h", desc = " References", icon = { icon = " ", color = "yellow" } },
        { "<leader>j", desc = " Jump to Definition", icon = { icon = "󰑮 ", color = "yellow" } },
        { "<leader>?", desc = " Buffer Keymaps", icon = { icon = "  ", color = "yellow" } },
        { "<leader><leader>", desc = "Search Buffers", icon = { icon = " ", color = "yellow" } },
        { "<leader>/", desc = " Grep Buffer", icon = { icon = "󰮗 ", color = "yellow" } },
        { "<leader>gg", desc = " LazyGit", icon = { icon = "󰋣 ", color = "purple" } },
        { "<leader>gl", desc = " LazyGit Log", icon = { icon = "󰋣 ", color = "purple" } },
        { "<leader>gf", desc = " LazyGit File History", icon = { icon = "󰋣 ", color = "purple" } },

        { "<leader>aa", desc = "Toggle ", icon = { icon = " ", color = "yellow" } },
        { "<leader>ad", desc = "Diagnostic Help", icon = { icon = " ", color = "yellow" } },
        { "<leader>aq", desc = "Prompt Actions", icon = { icon = " ", color = "yellow" } },
        { "<leader>ap", desc = "Quick Chat", icon = { icon = " ", color = "yellow" } },
        { "<leader>ax", desc = "Clear", icon = { icon = " ", color = "yellow" } },

        { "<leader>gG", hidden = true },
        { "<leader>gL", hidden = true },
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
      LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
      wk.register(opts.defaults)
    end
  end,
}
