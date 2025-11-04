return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      -- Detection methods in order of priority
      detection_methods = { "pattern", "lsp" },

      -- Patterns to detect project root
      patterns = {
        ".git",
        "go.mod", -- For your Go projects
        "angular.json", -- For your Angular projects
        "package.json",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
      },

      -- Don't automatically change directory (you can toggle this)
      silent_chdir = false,

      -- What scope to change directory (global, tab, win)
      scope_chdir = "win",
    })
  end,
}
