return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  opts = {
    highlights = {
      -- Line-level: accepts highlight group names or hex colors (e.g., "#2ea043")
      line_insert = "#1B2018",
      line_delete = "#2A151A", -- Line-level deletions

      char_brightness = 2.0, -- Auto-adjust based on your colorscheme
    },
    -- Override character colors explicitly
    -- highlights = {
    --   line_insert = "DiffAdd",
    --   line_delete = "DiffDelete",
    --   char_insert = "#1a4d1a",
    --   char_delete = "#ff7b72",
    -- },
  },
}
