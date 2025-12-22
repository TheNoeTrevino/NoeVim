return {
  "nvimtools/hydra.nvim",
  config = function()
    local Hydra = require("hydra")
    local gitsigns = require("gitsigns")

    local hint = [[
 _<C-K>_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _<C-L>_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Esc>_: exit
]]

    Hydra({
      name = "Git",
      hint = hint,
      config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
          float_opts = { border = "rounded" },
        },
        on_enter = function()
          -- vim.cmd("mkview")
          -- vim.cmd("silent! %foldopen!")
          -- vim.bo.modifiable = false
          -- vim.cmd("Gitsigns toggle_linehl true")
        end,
        on_exit = function()
          -- local cursor_pos = vim.api.nvim_win_get_cursor(0)
          -- vim.cmd("loadview")
          -- vim.api.nvim_win_set_cursor(0, cursor_pos)
          -- vim.cmd("normal zv")
          -- vim.cmd("Gitsigns toggle_linehl false")
          -- vim.cmd("Gitsigns toggle_deleted false")
        end,
      },
      mode = { "n", "x" },
      body = "<leader>o",
      heads = {
        { "<C-K>", "<cmd>Gitsigns next_hunk<cr>", { desc = "next hunk" } },
        { "<C-L>", "<cmd>Gitsigns prev_hunk<cr>", { desc = "prev hunk" } },
        { "s", "<cmd>Gitsigns stage_hunk<CR>", { silent = true, desc = "stage hunk" } },
        { "u", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "undo last stage" } },
        { "S", "<cmd>Gitsigns stage_buffer<CR>", { desc = "stage buffer" } },
        { "p", "<cmd>Gitsigns preview_hunk<CR>", { desc = "preview hunk" } },
        { "d", "<cmd>Gitsigns toggle_deleted<CR>", { nowait = true, desc = "toggle deleted" } },
        { "b", "<cmd>Gitsigns blame_line<CR>", { desc = "blame" } },
        {
          "B",
          function()
            gitsigns.blame_line({ full = true })
          end,
          { desc = "blame show full" },
        },
        { "/", gitsigns.show, { exit = true, desc = "show base file" } }, -- show the base of the file
        { "<Esc>", nil, { exit = true, nowait = true, desc = "exit" } },
      },
    })
  end,
}
