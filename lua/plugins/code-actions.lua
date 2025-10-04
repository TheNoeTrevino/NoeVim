return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  event = "LspAttach",
  opts = {
    --- The backend to use, currently only "vim", "delta", "difftastic", "diffsofancy" are supported
    backend = "delta",

    -- The picker to use, "telescope", "snacks", "select", "buffer", "fzf-lua" are supported
    -- And it's opts that will be passed at the picker's creation, optional
    --
    -- You can also set `picker = "<picker>"` without any opts.
    picker = {
      "buffer",
      opts = {
        hotkeys = false, -- Enable hotkeys for quick selection of actions
        hotkeys_mode = "text_diff_based", -- Modes for generating hotkeys
        auto_preview = true, -- Enable or disable automatic preview
        auto_accept = false, -- Automatically accept the selected action
        position = "right", -- Position of the picker window
        winborder = "single", -- Border style for picker and preview windows
        custom_keys = {
          { key = "m", pattern = "Fill match arms" },
          { key = "r", pattern = "Rename.*" }, -- Lua pattern matching
        },
      },
    },
    backend_opts = {
      delta = {
        -- Header from delta can be quite large.
        -- You can remove them by setting this to the number of lines to remove
        header_lines_to_remove = 4,

        -- The arguments to pass to delta
        -- If you have a custom configuration file, you can set the path to it like so:
        -- args = {
        --     "--config" .. os.getenv("HOME") .. "/.config/delta/config.yml",
        -- }
        args = {
          "--no-gitconfig",
        },
      },
    },

    resolve_timeout = 100, -- Timeout in milliseconds to resolve code actions

    signs = {
      quickfix = { "", { link = "DiagnosticWarning" } },
      others = { "", { link = "DiagnosticWarning" } },
      refactor = { "", { link = "DiagnosticInfo" } },
      ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
      ["refactor.extract"] = { "", { link = "DiagnosticError" } },
      ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
      ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
      ["source"] = { "", { link = "DiagnosticError" } },
      ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
      ["codeAction"] = { "", { link = "DiagnosticWarning" } },
    },
  },
}
