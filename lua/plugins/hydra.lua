return {
  "nvimtools/hydra.nvim",
  lazy = true,
  config = function()
    local Hydra = require("hydra")
    local gitsigns = require("gitsigns")

    local hint = [[
 _<C-K>_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _<C-L>_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Esc>_: exit               _C_: commit
]]

    Hydra({
      name = "Git",
      hint = hint,
      config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
          float_opts = { border = "single" },
        },
        on_enter = function()
          -- vim.cmd("mkview")
          -- vim.cmd("silent! %foldopen!")
          -- vim.bo.modifiable = false
          -- vim.cmd("Gitsigns toggle_linehl true")
          vim.cmd("Gitsigns toggle_word_diff true")
          vim.cmd("Gitsigns toggle_linehl true")
        end,
        on_exit = function()
          -- local cursor_pos = vim.api.nvim_win_get_cursor(0)
          -- vim.cmd("loadview")
          -- vim.api.nvim_win_set_cursor(0, cursor_pos)
          -- vim.cmd("normal zv")
          -- vim.cmd("Gitsigns toggle_linehl false")
          -- vim.cmd("Gitsigns toggle_deleted false")
          vim.cmd("Gitsigns toggle_word_diff false")
          vim.cmd("Gitsigns toggle_linehl false")
        end,
      },
      mode = { "n", "x" },
      body = "<leader>G",
      heads = {
        { "<C-K>", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next Hunk" } },
        { "<C-L>", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev Hunk" } },
        { "C", "<cmd>G commit<CR>", { silent = true, desc = "Commit" } },
        { "s", "<cmd>Gitsigns stage_hunk<CR>", { silent = true, desc = "Stage Hunk" } },
        { "u", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo Last Stage" } },
        { "S", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Stage Buffer" } },
        { "p", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" } },
        { "d", "<cmd>Gitsigns toggle_deleted<CR>", { nowait = true, desc = "Toggle Deleted" } },
        { "b", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame" } },
        {
          "B",
          function()
            gitsigns.blame_line({ full = true })
          end,
          { desc = "Blame Show Full" },
        },
        { "/", gitsigns.show, { exit = true, desc = "show base file" } }, -- show the base of the file
        { "<Esc>", nil, { exit = true, nowait = true, desc = "exit" } },
      },
    })

    local dap = require("dap")

    local dap_hint = [[
 _n_: step over   _s_: Continue/Start   _b_: Breakpoint     _K_: Eval
 _i_: step into   _x_: Quit             ^ ^                 ^ ^
 _o_: step out    _X_: Stop             ^ ^
 _c_: to cursor   _C_: Close UI
 ^
 ^ ^              _q_: exit
]]
    Hydra({
      name = "Debug",
      hint = hint,
      config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
          float_opts = { border = "single" },
        },
        on_enter = function()
          -- vim.cmd("mkview")
          -- vim.cmd("silent! %foldopen!")
          -- vim.bo.modifiable = false
          -- vim.cmd("Gitsigns toggle_linehl true")
          vim.cmd("Gitsigns toggle_word_diff true")
          vim.cmd("Gitsigns toggle_linehl true")
        end,
        on_exit = function()
          -- local cursor_pos = vim.api.nvim_win_get_cursor(0)
          -- vim.cmd("loadview")
          -- vim.api.nvim_win_set_cursor(0, cursor_pos)
          -- vim.cmd("normal zv")
          -- vim.cmd("Gitsigns toggle_linehl false")
          -- vim.cmd("Gitsigns toggle_deleted false")
          vim.cmd("Gitsigns toggle_word_diff false")
          vim.cmd("Gitsigns toggle_linehl false")
        end,
      },
      mode = { "n", "x" },
      body = "<leader>D",
      heads = {
        {
          "B",
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Breakpoint Condition",
        },
        {
          "b",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle Breakpoint",
        },
        {
          "c",
          function()
            require("dap").continue()
          end,
          desc = "Continue",
        },
        {
          "a",
          function()
            require("dap").continue({ before = get_args })
          end,
          desc = "Run with Args",
        },
        {
          "C",
          function()
            require("dap").run_to_cursor()
          end,
          desc = "Run to Cursor",
        },
        {
          "g",
          function()
            require("dap").goto_()
          end,
          desc = "Go to Line (No Execute)",
        },
        {
          "i",
          function()
            require("dap").step_into()
          end,
          desc = "Step Into",
        },
        {
          "k",
          function()
            require("dap").down()
          end,
          desc = "Down",
        },
        {
          "l",
          function()
            require("dap").up()
          end,
          desc = "Up",
        },
        {
          "l",
          function()
            require("dap").run_last()
          end,
          desc = "Run Last",
        },
        {
          "O",
          function()
            require("dap").step_out()
          end,
          desc = "Step Out",
        },
        {
          "o",
          function()
            require("dap").step_over()
          end,
          desc = "Step Over",
        },
        {
          "p",
          function()
            require("dap").pause()
          end,
          desc = "Pause",
        },
        {
          "r",
          function()
            require("dap").repl.toggle()
          end,
          desc = "Toggle REPL",
        },
        {
          "s",
          function()
            require("dap").session()
          end,
          desc = "Session",
        },
        {
          "t",
          function()
            require("dap").terminate()
          end,
          desc = "Terminate",
        },
        {
          "w",
          function()
            require("dap.ui.widgets").hover()
          end,
          desc = "Widgets",
        },
        {
          "Pt",
          function()
            require("dap-python").test_method()
          end,
          desc = "Debug Method",
          ft = "python",
        },
        {
          "Pc",
          function()
            require("dap-python").test_class()
          end,
          desc = "Debug Class",
          ft = "python",
        },
      },
    })
  end,
}
