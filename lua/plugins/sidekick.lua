return {
  "folke/sidekick.nvim",
  cmd = "Sidekick",
  opts = {
    ---@class sidekick.Config
    nes = { enabled = true },
    cli = {
      watch = true, -- notify Neovim of file changes done by AI CLI tools
      ---@class sidekick.win.Opts
      win = {
        --- This is run when a new terminal is created, before starting it.
        --- Here you can change window options `terminal.opts`.
        ---@param terminal sidekick.cli.Terminal
        config = function(terminal) end,
        wo = {}, ---@type vim.wo
        bo = {}, ---@type vim.bo
        layout = "right", ---@type "float"|"left"|"bottom"|"top"|"right"
        --- Options used when layout is "float"
        ---@type vim.api.keyset.win_config
        float = {
          width = 0.9,
          height = 0.9,
        },
        -- Options used when layout is "left"|"bottom"|"top"|"right"
        ---@type vim.api.keyset.win_config
        split = {
          width = 80,
          height = 20,
        },
        keys = {
          hide_n = { "q", "hide", mode = "n" }, -- hide the terminal window in normal mode
          hide_t = { "<c-/>", "hide" },         -- hide the terminal window in terminal mode
          hide_t = { "<c-_>", "hide" },         -- tmux
          win_p = { "<c-w>p", "blur" },         -- leave the cli window
          prompt = { "<c-p>", "prompt" },       -- insert prompt or context

          nav_left = { "<c-j>", "nav_left", expr = true, desc = "navigate to the left window" },
          nav_down = { "<c-k>", "nav_down", expr = true, desc = "navigate to the below window" },
          nav_up = { "<c-l>", "nav_up", expr = true, desc = "navigate to the above window" },
          nav_right = { "<c-;>", "nav_right", expr = true, desc = "navigate to the right window" },
        },
      },
      tools = {
        ["qwen2.5-coder:7b"] = {
          cmd = { "aider", "--model", "ollama/qwen2.5-coder:7b" },
        },
        ["qwen2.5-coder:32b"] = {
          cmd = { "aider", "--model", "ollama/qwen2.5-coder:32b" },
        },
      },
      ---@class sidekick.cli.Mux
      ---@field backend? "tmux"|"zellij" Multiplexer backend to persist CLI sessions
      mux = {
        backend = "tmux",
        enabled = true,
        -- terminal: new sessions will be created for each CLI tool and shown in a Neovim terminal
        -- window: when run inside a terminal multiplexer, new sessions will be created in a new tab
        -- split: when run inside a terminal multiplexer, new sessions will be created in a new split
        create = "terminal", ---@type "terminal"|"window"|"split"
        split = {
          vertical = true, -- vertical or horizontal split
          size = 0.3,      -- size of the split (0-1 for percentage)
        },
      },
    },
    copilot = {
      -- track copilot's status with `didChangeStatus`
      status = {
        enabled = true,
      },
    },
    debug = false, -- enable debug logging
  },
  -- stylua: ignore
  keys = {
    -- nes is also useful in normal mode
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select({ filter = { installed = true } })
      end,
      -- Or to select only installed tools:
      desc = "Select CLI",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Select Prompt",
    },
    {
      "<c-.>",
      function() require("sidekick.cli").focus() end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Switch Focus",
    },
    -- Example of a keybinding to open Claude directly
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      desc = "Sidekick Claude Toggle",
    },
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if require("sidekick").nes_jump_or_apply() then
          return -- jumped or applied
        else
          vim.cmd("Sidekick nes update")
        end

        return "<tab>"
      end,
      mode = { "i", "n" },
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<leader>nu",
      function()
        vim.cmd("Sidekick nes update")
      end,
      desc = "NES Update",
    },
    {
      "<leader>nt",
      function()
        vim.cmd("Sidekick nes toggle")
      end,
      desc = "Sidekick NES Toggle",
    },
  },
}
