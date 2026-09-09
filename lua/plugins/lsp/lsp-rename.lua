-- Everything rename-related lives here: both the symbol rename (<leader>cr, inc-rename with
-- a Snacks input float) and the file rename (<leader>cR, Snacks.rename, which notifies the LSP
-- via workspace/willRenameFiles). Neo-tree wires Snacks.rename.on_rename_file separately, as an
-- event handler rather than a keymap -- see neotree.lua.
return {

  -- Rename with cmdpreview
  desc = "Incremental LSP renaming based on Neovim's command-preview feature",
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {
      -- Routes the input through Snacks.input instead of the cmdline. inc-rename builds the
      -- input buffer inside its command-preview callback, so the float appears on the first
      -- keystroke after <leader>cr, not on <CR>.
    },
  },

  -- LSP Keymaps
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              -- inc-rename sends the request to the first rename-capable client only;
              -- vim.lsp.buf.rename chains every one of them and prompts once per client.
              "<leader>cr",
              function()
                local inc_rename = require("inc_rename")
                return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
              end,
              expr = true,
              desc = "Rename (inc-rename.nvim)",
              has = "rename",
            },
            {
              "<leader>cR",
              function()
                Snacks.rename.rename_file()
              end,
              desc = "Rename File",
              mode = { "n" },
              has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
            },
          },
        },
      },
    },
  },
}
