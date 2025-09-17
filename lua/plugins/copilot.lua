return {
  "CopilotC-Nvim/CopilotChat.nvim",
  event = "VeryLazy",
  branch = "canary",
  cmd = "CopilotChat",
  opts = function()
    return {
      -- model = "claude-3.7-sonnet",
      auto_insert_mode = true,
      show_folds = false,
      show_help = true,
      question_header = "  Noe ",
      answer_header = "  Copilot ",
      window = {
        layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
        relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
        border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = " Chat - gh for help ", -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },
      -- default mappings
      mappings = {
        close = {
          normal = "<ESC>",
          insert = "<C-c>",
        },
      },
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
      require("CopilotChat.integrations.cmp").setup(),
    }
  end,
  keys = {
    { "<leader>aa", "<CMD>CopilotChat<CR>", desc = "Explain", mode = { "n", "v" } },
    { "<leader>ae", "<CMD>CopilotChatExplain<CR>", desc = "Explain", mode = { "n", "v" } },
    { "<leader>ad", "<CMD>CopilotChatFixDiagnostic<CR>", desc = "Diagnostics", mode = { "n", "v" } },
    { "<leader>af", "<CMD>CopilotChatFix<CR>", desc = "Fix", mode = { "n", "v" } },
    { "<leader>am", "<CMD>CopilotChatModels<CR>", desc = "Models", mode = { "n", "v" } },
    { "<leader>ac", "<CMD>CopilotChatCommit<CR>", desc = "Commit", mode = { "n", "v" } },
    { "<leader>as", "<CMD>CopilotChatCommitStaged<CR>", desc = "Commit - Staged", mode = { "n", "v" } },
    { "<leader>ar", "<CMD>CopilotChatCommitReview<CR>", desc = "Commit - Review", mode = { "n", "v" } },
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "v" },
    },
  },
}
