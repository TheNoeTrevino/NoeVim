-- Task runner (LazyVim's editor.overseer extra).
--
-- Loads on UIEnter instead of LazyVim's `lazy = false` so it stays off the
-- startup path but is still up before the first keypress -- overseer needs to be
-- loaded early enough to register its template providers and pick up the
-- strategy/component defaults before any task runs.
--
-- `dap = false` in opts plus `require("overseer").enable_dap()` from the nvim-dap
-- spec below: that keeps overseer from pulling nvim-dap in itself, and instead
-- wires the `overseer` preLaunchTask/postDebugTask support only once dap loads.
return {
  {
    "stevearc/overseer.nvim",
    event = "UIEnter",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerRun",
      "OverseerTaskAction",
    },
    opts = {
      dap = false,
      task_list = {
        keymaps = {
          -- <C-j>/<C-k> stay window navigation.
          ["<C-j>"] = false,
          ["<C-k>"] = false,
        },
      },
      form = {
        win_opts = {
          winblend = 0,
        },
      },
      task_win = {
        win_opts = {
          winblend = 0,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>ow", function() vim.cmd("OverseerToggle!") end, desc = "Toggle", },
      { "<leader>oo", function() vim.cmd("OverseerRun") end, desc = "Run task", },
      { "<leader>ot", function() vim.cmd("OverseerTaskAction") end, desc = "Task action", },
      { "<leader>oi", function()
        vim.ui.input({ prompt = "Task name: " }, function(input)
          if input then
            vim.cmd("OverseerShell " .. input)
          end
        end)
      end, desc = "Task input", },
    },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>o", group = "Overseer", icon = { icon = "󰑮 ", color = "green" } },
      },
    },
  },

  -- Edgy integration
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Overseer",
        ft = "OverseerList",
        open = function()
          require("overseer").open()
        end,
      })
    end,
  },

  -- Run tests through overseer tasks.
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      opts.consumers = opts.consumers or {}
      opts.consumers.overseer = require("neotest.consumers.overseer")
    end,
  },

  -- launch.json preLaunchTask / postDebugTask support.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      require("overseer").enable_dap()
    end,
  },
}
