return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  cmd = "CopilotChat",
  opts = function()
    return {
      auto_insert_mode = true,
      show_folds = false,
      show_help = true,
      question_header = "  Noe ",
      answer_header = "  Copilot ",
      window = {
        layout = "float", -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.8, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.8, -- fractional height of parent, or absolute height in rows when > 1
        -- Ohehehptions below only apply to floating windows
        relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
        border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = nil, -- title of chat window
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
}
