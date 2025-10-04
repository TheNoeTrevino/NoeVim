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
      "snacks",
    },
    backend_opts = {
      delta = {
        header_lines_to_remove = 4,
        args = {
          "--no-gitconfig",
        },
      },
    },

    resolve_timeout = 100, -- Timeout in milliseconds to resolve code actions

    keymaps = {
      select = { "<CR>", ";" },
      close = { "<esc>" },
    },

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
