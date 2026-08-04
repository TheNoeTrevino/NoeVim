-- Everything rename-related lives here: both the symbol rename (<leader>cr, inc-rename with
-- cmdline preview) and the file rename (<leader>cR, Snacks.rename, which notifies the LSP via
-- workspace/willRenameFiles). Neo-tree wires Snacks.rename.on_rename_file separately, as an
-- event handler rather than a keymap -- see neotree.lua.
return {

  -- Rename with cmdpreview
  desc = "Incremental LSP renaming based on Neovim's command-preview feature",
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
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

  --- Noice integration
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      presets = { inc_rename = true },
      cmdline = {
        format = {
          -- The preset positions this float at the cursor (relative = "cursor"), but every
          -- cmdline format inherits `cmdline.view`, which noice.lua sets to the bottom
          -- "cmdline" view -- that view ignores the position/size opts, so the preset ends
          -- up looking exactly like a plain cmdline. Pin it back to the popup view.
          IncRename = { view = "cmdline_popup", title = " Rename " },
        },
      },
    },
  },
}
