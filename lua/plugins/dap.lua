return {
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
      return {
        -- stylua: ignore start
        { "<leader>d", group = "  Debug" },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition", },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
        { "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
        { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args", },
        { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
        { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)", },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
        { "<leader>dk", function() require("dap").down() end, desc = "Down", },
        { "<leader>dl", function() require("dap").up() end, desc = "Up", },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last", },
        { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out", },
        { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", },
        { "<leader>dp", function() require("dap").pause() end, desc = "Pause", },
        { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
        { "<leader>ds", function() require("dap").session() end, desc = "Session", },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate", },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets", },
        { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug Method", ft = "python", },
        { "<leader>dPc", function() require("dap-python").test_class() end, desc = "Debug Class", ft = "python", },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = function()
      return {
        -- stylua: ignore start
        { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI", },
        { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" }, },
      }
    end,
    opts = {
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.4,
            },
            {
              id = "watches",
              size = 0.4,
            },
            {
              id = "breakpoints",
              size = 0.1,
            },
            {
              id = "stacks",
              size = 0.1,
            },
          },
          position = "left",
          size = 50,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 10,
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
        vim.notify("Debugging Session has Ended", vim.log.levels.INFO, { title = " " })
      end
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    opts = { rocks = { rocks = false, hererocks = false } },
    -- stylua: ignore
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
    },
    config = function()
      require("dap-python").setup("debugpy-adapter")
    end,
  },
}
