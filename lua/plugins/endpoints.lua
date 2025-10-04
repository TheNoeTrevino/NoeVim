return {
  "zerochae/endpoint.nvim",
  cmd = {
    "Endpoint",
  },
  config = function()
    require("endpoint").setup({
      picker = {
        type = "snacks",
        previewer = {
          enable_highlighting = true,
        },
      },

      -- Cache configuration
      cache = {
        mode = "session", -- "none", "session", "persistent"
      },

      -- UI configuration
      ui = {
        show_icons = true,
        show_method = true,
        methods = {
          GET = { icon = "", color = "SnacksPickerCode" },
          POST = { icon = "", color = "LspSignatureActiveParameter" },
          PUT = { icon = "", color = "SnacksPickerIconFunction" },
          DELETE = { icon = "", color = "SnacksPickerGitIssue" },
          PATCH = { icon = "", color = "SnacksPickerGitStatusModified" },
          ROUTE = { icon = "", color = "CmpItemKindUnit" },
        },
      },
    })
  end,
}
