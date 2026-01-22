return {
  "https://gitlab.com/shmerl/session-keys.git",
  init = function()
    require("session-keys").sessions.dap = {
      -- stylua: ignore
      n = { -- mode 'n'
        { lhs = 'c',  rhs = function() require('dap').continue() end, opts = { desc = 'Run, continue' } },
        { lhs = 'C', rhs = function() require('dap').run_to_cursor() end, opts = { desc = 'Run to cursor' } },
        { lhs = 'b',  rhs = function() require('dap').toggle_breakpoint() end, opts = { desc = 'Toggle breakpoint' } },
        { lhs = 'o', rhs = function() require('dap').step_over() end, opts = { desc = 'Step over' } },
        { lhs = 'i', rhs = function() require('dap').step_into() end, opts = { desc = 'Step into' } },
        { lhs = 'O', rhs = function() require('dap').step_out() end, opts = { desc = 'Step out' } },

        { lhs = 't',  rhs = function() require('dap').terminate() end, opts = { desc = 'Terminate' } },
        { lhs = 'D', rhs = function() require('dap').disconnect({ terminateDebuggee = false }) end, opts = { desc = 'Disconnect' } },
        { lhs = 'L', rhs = function() require('dap').run_last() end, opts = { desc = 'Run last' } },

        { lhs = '<down>',  rhs = function() require('dap').down() end, opts = { desc = 'Go down in current stacktrace without stepping' } },
        { lhs = '<up>', rhs = function() require('dap').up() end, opts = { desc = 'Go up in current stacktrace without stepping' } },

        { lhs = 'p',  rhs = function() require('dap').pause() end, opts = { desc = 'Pause thread' } },

        { lhs = 'x', rhs = function() require('dap').reverse_continue() end, opts = { desc = 'Reverse continue' } },
        { lhs = 'B', rhs = function() require('dap').step_back() end, opts = { desc = 'Step back' } }
      },
    }
    vim.keymap.set("n", "<leader>dd", function()
      vim.notify("Toggling debugger mappings...")
      require("session-keys"):toggle("dap")
    end)
  end,
}
