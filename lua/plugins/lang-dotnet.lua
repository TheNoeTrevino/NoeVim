return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp", "fsharp" } },
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
          -- Defaults to true, which means "no solution found upward" escalates to scanning the
          -- entire tree below cwd for one. The built-in filter only skips dotfile dirs, so that
          -- picks up vendored solutions in repos with no .NET in them -- lz4 ships one under
          -- frontend/node_modules -- and then `dotnet build` runs against it, which both fails
          -- and parks root() long enough for its shared `solution` upvalue to be raced to nil.
          -- Upward discovery still finds the solution in any repo opened at or below its root.
          --
          -- Do NOT reach for discovery_directory_filter here instead: the adapter feeds it to
          -- two call sites with opposite polarity. root() uses `not filter(dir)`, so true means
          -- ignore, but filter_dir returns it verbatim (init.lua:193) where neotest reads true
          -- as descend (lib/file/find.lua:53). One function cannot satisfy both.
          broad_recursive_discovery = false,
        },
      },
    },
  },
}
