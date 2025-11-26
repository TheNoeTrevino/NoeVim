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
          {
            "K",
            function()
              vim.lsp.buf.hover()
            end,
            mode = "n",
          },
          { "<leader>ca", false, mode = "n" },
        },
      },
      copilot = { enabled = false },
      omnisharp = {
        enabled = false,
        mason = false,
        autostart = false,
      },
      ruff = {
        mason = false,
        autostart = false,
      },
      markdownlint = {
        mason = false,
        autostart = false,
      },
    },
    diagnostics = {
      float = {
        border = "single",
      },
    },
  },
}
