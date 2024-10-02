return {
  "gcmt/vessel.nvim",
  event = "VeryLazy",
  config = function()
    require("vessel").setup({
      create_commands = true,
      commands = {
        view_marks = "Marks",
        view_jumps = "Jumps",
      },
      jumps = {
        mappings = {
          -- ctrl_o = "k",
          -- ctrl_i = "l",
          jump = { ";", "<cr>" },
          close = { "q", "<esc>" },
          clear = { "C" },
        },
      },
      marks = {
        mappings = {
          close = { "q", "<esc>" },
          delete = { "d" },
          -- next_group = { "k" },
          -- prev_group = { "l" },
          jump = { ";", "<cr>" },
          keepj_jump = { "o" },
          tab = { "t" },
          keepj_tab = { "T" },
          split = { "s" },
          keepj_split = { "S" },
          vsplit = { "v" },
          keepj_vsplit = { "V" },
        },
      },
    })
  end,
  vim.keymap.set("n", "<leader>m", "<cmd>Marks<CR>", { desc = "Marks" }),
  vim.keymap.set("n", "<leader>n", function()
    require("vessel").view_jumps({}, function(jump, context)
      return vim.startswith(jump.bufpath, vim.fn.getcwd() .. "/")
    end)
  end),
}
