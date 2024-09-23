return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  cmd = "CopilotChat",
  opts = function()
    return {
      auto_insert_mode = true,
      show_help = true,
      question_header = " ",
      answer_header = "  Copilot ",
      window = {
        layout = "float", -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.7, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.7, -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
        border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = nil, -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
    }
  end,
}
