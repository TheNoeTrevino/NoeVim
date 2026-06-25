-- Setup: npm install @angular/language-service --no-save
-- (use --save-dev in projects that need a pinned version).
local Util = require("util")
return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "angular", "scss" })
      end
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html" },
        callback = function()
          vim.treesitter.start(nil, "angular")
        end,
      })
    end,
  },

  -- LSP Servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        angularls = {},
      },
      setup = {
        angularls = function()
          Snacks.util.lsp.on({ name = "angularls" }, function(_, client)
            --HACK: disable angular renaming capability due to duplicate rename popping up
            client.server_capabilities.renameProvider = false
          end)
        end,
      },
    },
  },

  -- Configure tsserver plugin
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- vtsls is defined in lang-typescript-vtsls.lua, which may merge after this
      -- fragment depending on load order; ensure the table exists before extending.
      opts.servers = opts.servers or {}
      opts.servers.vtsls = opts.servers.vtsls or {}
      Util.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@angular/language-server",
          location = Util.get_pkg_path("angular-language-server", "/node_modules/@angular/language-server"),
          enableForWorkspaceTypeScriptVersions = false,
        },
      })
    end,
  },

  -- formatting
  {
    "conform.nvim",
    opts = function(_, opts)
      -- prettier is always part of this config (formatting-prettier.lua).
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.htmlangular = { "prettier" }
    end,
  },
}
