vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
})

-- Kulala maps <C-h>/<C-l> (prev/next tab) buffer-locally in its response UI
-- (filetype "kulala_ui"). Delete those so they fall through to our global
-- window-navigation maps. Done via autocmd (not `kulala_keymaps = false`) because
-- kulala's show_help crashes on falsy entries. Scheduled to run after kulala
-- installs its keymaps.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "kulala_ui",
  group = vim.api.nvim_create_augroup("kulala_unmap_nav", { clear = true }),
  callback = function(args)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      pcall(vim.keymap.del, "n", "<C-h>", { buffer = args.buf })
      pcall(vim.keymap.del, "n", "<C-l>", { buffer = args.buf })
    end)
  end,
})

-- Open the kulala HTTP request store for browsing.
-- Works from any buffer (no filetype dependency). Expands ~, ensures the
-- directory exists, then opens Neo-tree scoped to that dir in a NEW TAB.
-- Uses reveal_force_cwd so Neo-tree doesn't prompt "File not in cwd?" when
-- the store lives outside the current project root.
local function browse_saved_requests()
  local path = vim.fn.expand("~/.local/share/kulala")
  vim.fn.mkdir(path, "p")

  vim.cmd("tabnew")
  -- Scope this tab's cwd to the store so git and cwd-relative tools work here
  -- without touching the cwd of any other tab.
  vim.cmd.tcd(vim.fn.fnameescape(path))
  require("neo-tree.command").execute({
    action = "show",
    source = "filesystem",
    position = "left",
    dir = path,
    reveal_force_cwd = true,
  })
end

return {
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    keys = {
        -- stylua: ignore start
      { "<leader>r", "", desc = "+Rest" },
      { "<leader>rb", function() browse_saved_requests() end,             desc = "Browse saved requests" },
      { "<leader>r.", function() require("kulala").scratchpad() end,       desc = "Open scratchpad" },
      { "<leader>rc", function() require("kulala").copy() end,             desc = "Copy as cURL",    ft = "http" },
      { "<leader>rC", function() require("kulala").from_curl() end,        desc = "Paste from curl", ft = "http" },
      { "<leader>re", function() require("kulala").set_selected_env() end, desc = "Set environment", ft = "http" },
      {
        "<leader>rg",
        function() require("kulala").download_graphql_schema() end,
        desc = "Download GraphQL schema",
        ft = "http",
      },
      { "<leader>ri", function() require("kulala").inspect() end,     desc = "Inspect current request",  ft = "http" },
      { "<leader>rn", function() require("kulala").jump_next() end,   desc = "Jump to next request",     ft = "http" },
      { "<leader>rp", function() require("kulala").jump_prev() end,   desc = "Jump to previous request", ft = "http" },
      { "<leader>rq", function() require("kulala").close() end,       desc = "Close window",             ft = "http" },
      { "<leader>rr", function() require("kulala").replay() end,      desc = "Replay the last request" },
      { "<leader>rs", function() require("kulala").run() end,         desc = "Send the request",         ft = "http" },
      { "<leader>rS", function() require("kulala").show_stats() end,  desc = "Show stats",               ft = "http" },
      { "<leader>rt", function() require("kulala").toggle_view() end, desc = "Toggle headers/body",      ft = "http" },
      -- stylua: ignore end
    },
    opts = {
      response_format = {
        indent = 2,
        expand_tabs = true,
        sort_keys = false,
      },

      ui = {
        -- display mode: possible values: "split", "float"
        display_mode = "split",
        -- split direction: possible values: "above", "right", "below", "left", fun(): "above"|"right"|"below"|"left"
        split_direction = "below",
        -- window options to override win_config: width/height/split/vertical.., buffer/window options
        -- possible values: false, "float"
        show_variable_info_text = false,
        -- icons position: "signcolumn"|"on_request"|"above_request"|"below_request" or nil to disable
        show_icons = "on_request",
        -- default icons
        icons = {
          inlay = {
            loading = "",
            done = "",
            error = "",
          },
          lualine = "🐼",
          textHighlight = "WarningMsg", -- highlight group for request elapsed time
          loadingHighlight = "Normal",
          doneHighlight = "String",
          errorHighlight = "ErrorMsg",
        },

        -- enable/disable request summary in the output window
        show_request_summary = true,

        -- do not show responses over maximum size, in bytes
        max_response_size = 32768,

        -- used by `Copy as Curl` command to determine whether to inline request body
        max_request_size = 2048,

        -- scratchpad default contents
        -- Authored as a single [[ ]] long string for readability (no per-line
        -- quoting/escaping), then split into the line list kulala expects.
        scratchpad_default_contents = vim.split(
          [[
@MY_VALUE=1

# @name scratchpad
POST https://echo.kulala.app/post/{{MY_VALUE}} HTTP/1.1
accept: application/json
content-type: application/json

{
  "foo": "bar"
}

> {%
client.log("First name: " + response.body.firstName)
client.global.set("accessToken", response.body.accessToken);
%}]],
          "\n"
        ),

        -- Settings for pickers used for Environment, Authentication and Requests Managers
      },

      lsp = {
        ---enable/disable built-in LSP server
        ---@type boolean
        enable = true,

        ---filetypes to attach Kulala LSP to
        ---@type string[]
        filetypes = {
          "http",
          "rest",
          "javascript",
          "typescript",
          "lua",
        },

        ---Only scripts ending in *.http.js, *.http.ts and *.http.lua will be treated as HTTP scripts and
        ---have LSP capabilities, unless `enforce_external_script_naming_convention` is set to false.
        ---This allows users to have non-HTTP scripts with the same filetypes without LSP interference.
        ---@type boolean
        enforce_external_script_naming_convention = true,

        --enable/disable/customize  LSP keymaps
        ---@type boolean|table
        keymaps = false, -- disabled by default, as Kulala relies on default Neovim LSP keymaps

        on_attach = nil, -- function called when Kulala LSP attaches to the buffer
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "http", "graphql" },
    },
  },
}
