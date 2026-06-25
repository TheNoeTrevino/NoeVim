-- DAP. Single source of truth: the base spec (originally vendored from LazyVim's
-- dap.core extra: mason-nvim-dap, signs, vscode launch.json, virtual text) plus the
-- personal java configs, keymaps, dap-ui layout and dap-python wiring. Entries target
-- the same repos; lazy.nvim merges them, with the personal entries (last) winning.
local LazyVim = require("util")

---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

return {
  -- Base nvim-dap spec
  {
    "mfussenegger/nvim-dap",
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },

    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if LazyVim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(LazyVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },

  -- fancy UI for the debugger (base)
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "x"} },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- mason.nvim integration
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },

  -- Personal overrides: java launch configs + extended keymaps.
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    recommended = true,
    opts = function()
      local dap = require("dap")
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005, -- check on this for spring
        },
        {
          type = "java",
          request = "launch",
          name = "Debug JUnit Test (Manual)",
          mainClass = "", -- Will be filled dynamically by jdtls
        },
      }
    end,
    keys = function()
      local dap = require("dap")
      return {
        -- stylua: ignore start
        { "<leader>d", group = "  Debug" },
        { "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition", },
        { "<leader>db", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint", },
        { "<leader>dc", function() dap.continue() end, desc = "Continue", },
        { "<leader>da", function() dap.continue({ before = get_args }) end, desc = "Run with Args", },
        { "<leader>dC", function() dap.run_to_cursor() end, desc = "Run to Cursor", },
        { "<leader>dg", function() dap.goto_() end, desc = "Go to Line (No Execute)", },
        { "<leader>di", function() dap.step_into() end, desc = "Step Into", },
        { "<leader>dk", function() dap.down() end, desc = "Down", },
        { "<leader>dl", function() dap.up() end, desc = "Up", },
        { "<leader>dl", function() dap.run_last() end, desc = "Run Last", },
        { "<leader>dO", function() dap.step_out() end, desc = "Step Out", },
        { "<leader>do", function() dap.step_over() end, desc = "Step Over", },
        { "<leader>dp", function() dap.pause() end, desc = "Pause", },
        { "<leader>dr", function() dap.repl.toggle() end, desc = "Toggle REPL", },
        { "<leader>ds", function() dap.session() end, desc = "Session", },
        { "<leader>dt", function() dap.terminate() end, desc = "Terminate", },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets", },
        { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug Method", ft = "python", },
        { "<leader>dPc", function() require("dap-python").test_class() end, desc = "Debug Class", ft = "python", },
      }
    end,
  },

  -- Personal dap-ui layout + float view.
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = function()
      return {
        -- stylua: ignore start
        { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI", },
        { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",   mode = { "n", "v" }, },
        {
          "<leader>df",
          function()
            require('dapui').float_element(nil, {
              height = math.floor(vim.o.lines / 2),
              width = math.floor(vim.o.columns / 2),
              position = 'center',
              enter = true
            })
          end,
          desc = "Float View"
        },
      }
    end,
    opts = {
      layouts = {
        {
          elements = {
            {
              id = "repl",
              size = 0.15,
            },
            {
              id = "console",
              size = 0.15,
            },
            {
              id = "stacks",
              size = 0.35,
            },
            {
              id = "breakpoints",
              size = 0.35,
            },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            {
              id = "watches",
              size = 0.5,
            },
            {
              id = "scopes",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 12,
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        vim.notify("Debugging Session has Ended", vim.log.levels.INFO, { title = " " })
      end
    end,
  },

  -- python debugging
  {
    "mfussenegger/nvim-dap-python",
    opts = { rocks = { rocks = false, hererocks = false } },
    -- stylua: ignore
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
    },
    config = function()
      require("dap-python").setup("debugpy-adapter")
    end,
  },
}
