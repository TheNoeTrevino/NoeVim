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
        { "<leader>x", group = "  Debug" },
        { "<leader>xB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition", },
        { "<leader>xb", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
        { "<leader>xc", function() require("dap").continue() end, desc = "Continue", },
        { "<leader>xa", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args", },
        { "<leader>xC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
        { "<leader>xg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)", },
        { "<leader>xi", function() require("dap").step_into() end, desc = "Step Into", },
        { "<leader>xj", function() require("dap").down() end, desc = "Down", },
        { "<leader>xk", function() require("dap").up() end, desc = "Up", },
        { "<leader>xl", function() require("dap").run_last() end, desc = "Run Last", },
        { "<leader>xO", function() require("dap").step_out() end, desc = "Step Out", },
        { "<leader>xo", function() require("dap").step_over() end, desc = "Step Over", },
        { "<leader>xp", function() require("dap").pause() end, desc = "Pause", },
        { "<leader>xr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
        { "<leader>xs", function() require("dap").session() end, desc = "Session", },
        { "<leader>xt", function() require("dap").terminate() end, desc = "Terminate", },
        { "<leader>xw", function() require("dap.ui.widgets").hover() end, desc = "Widgets", },
        { "<leader>xPt", function() require("dap-python").test_method() end, desc = "Debug Method", ft = "python", },
        { "<leader>xPc", function() require("dap-python").test_class() end, desc = "Debug Class", ft = "python", },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = {
        -- stylua: ignore start
      { "<leader>xu", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>xe", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
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
        vim.notify("Debugging Session has Ended", vim.log.levels.INFO, { title = " " })
      end
    end,
  },
}
