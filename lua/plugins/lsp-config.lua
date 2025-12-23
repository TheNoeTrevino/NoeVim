return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      ["*"] = {
        keys = {
          { "<C-k>", false, mode = "i" },
          { "<leader>ss", false, mode = "n" },
          { "<leader>sS", false, mode = "n" },
          { "gr", false, mode = "n" },
          { "gI", false, mode = "n" },
          { "gY", false, mode = "n" },
          { "<leader>ca", false, mode = "v" },
          { "K", false, mode = "n" },
          -- {
          --   "K",
          --   function()
          --     vim.lsp.buf.hover()
          --   end,
          --   mode = "n",
          -- },
          {
            "<leader>ca",
            function()
              require("tiny-code-action").code_action({})
            end,
            mode = { "n", "x" },
          },
        },
      },
      copilot = { enabled = false },
      marksman = {
        enabled = true,
        mason = true,
        autostart = true,
      },
      -- omnisharp = {
      --   enabled = false,
      --   mason = false,
      --   autostart = false,
      -- },
      ruff = {
        mason = false,
        autostart = false,
      },
      markdownlint = {
        enabled = false,
        mason = false,
        autostart = false,
      },
    },
    diagnostics = {
      float = {
        border = "single",
        source = true,
      },
    },
  },
}
