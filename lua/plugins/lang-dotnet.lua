return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp", "fsharp" } },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.csharpier)
      table.insert(opts.sources, nls.builtins.formatting.fantomas)
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
        fsharp = { "fantomas" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "csharpier", "netcoredbg", "fantomas" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- fsautocomplete = {},
        -- Disabled: replaced by roslyn.nvim (see csharp.lua). Running OmniSharp
        -- alongside Roslyn causes duplicate diagnostics/completions on .cs.
        omnisharp = { enabled = false },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      if not dap.adapters["netcoredbg"] then
        -- Fall back to mason's bin dir when netcoredbg is not yet on PATH. exepath() is
        -- evaluated once, when this spec loads, so a mid-session :MasonInstall would
        -- otherwise leave the command empty until the next restart.
        local function netcoredbg_path()
          local on_path = vim.fn.exepath("netcoredbg")
          if on_path ~= "" then
            return on_path
          end
          return vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"
        end

        require("dap").adapters["netcoredbg"] = {
          type = "executable",
          command = netcoredbg_path(),
          args = { "--interpreter=vscode" },
          options = {
            detached = false,
          },
        }
      end
      for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = "netcoredbg",
              name = "Launch file",
              request = "launch",
              ---@diagnostic disable-next-line: redundant-parameter
              program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "Nsidorenco/neotest-vstest",
    },
    opts = {
      adapters = {
        ["neotest-vstest"] = {
          -- Here we can set options for neotest-vstest
        },
      },
    },
  },
}
