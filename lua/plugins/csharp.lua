return {
  -- NOTE: look at the lazy vim docs and see if there is anything you wanna add.
  -- we did this because we could not disable the damn omni sharp

  -- when you wanna enable for a computer put this:
  --
  -- require("mason").setup({
  --   registries = {
  --     "github:mason-org/mason-registry",
  --     "github:Crashdummyy/mason-registry",
  --   },
  -- })
  --
  -- in init.lua. then install rzls and rosalyn. i also completely disable
  -- omnisharp in the lspconfig
  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  },
  { "jlcrochet/vim-razor" },
  -- {
  --   "mfussenegger/nvim-dap",
  --   optional = true,
  --   opts = function()
  --     local dap = require("dap")
  --     if not dap.adapters["netcoredbg"] then
  --       require("dap").adapters["netcoredbg"] = {
  --         type = "executable",
  --         command = vim.fn.exepath("netcoredbg"),
  --         args = { "--interpreter=vscode" },
  --         options = {
  --           detached = false,
  --         },
  --       }
  --     end
  --     for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
  --       if not dap.configurations[lang] then
  --         dap.configurations[lang] = {
  --           {
  --             type = "netcoredbg",
  --             name = "Launch file",
  --             request = "launch",
  --             ---@diagnostic disable-next-line: redundant-parameter
  --             program = function()
  --               return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
  --             end,
  --             cwd = "${workspaceFolder}",
  --           },
  --         }
  --       end
  --     end
  --   end,
  -- },
}
