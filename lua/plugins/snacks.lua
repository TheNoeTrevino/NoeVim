return {
  "folke/snacks.nvim",
  opts = {
    indent = { enabled = false },
    statuscolumn = { enabled = false },
    dashboard = { enabled = false },
    scroll = {
      animate = {
        duration = { step = 15, total = 120 },
        easing = "linear",
      },
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false
      end,
    },
    scratch = {
      ft = function()
        return "markdown"
      end,
    },
    picker = {
      formatters = {
        file = {
          filename_first = true, -- display filename before the file path
          git_status_hl = true, -- use the git status highlight group for the filename
        },
      },
      prompt = " ",
      sources = {},
      focus = "input",
      layout = {
        reverse = true,
        layout = {
          box = "horizontal",
          backdrop = true,
          width = 0.9,
          height = 0.9,
          border = "none",
          {
            box = "vertical",
            { win = "list", title = " Results ", title_pos = "center", border = "single" },
            { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
          },
          {
            win = "preview",
            title = "{preview:Preview}",
            width = 0.6,
            border = "single",
            title_pos = "center",
          },
        },
      },
      ---@class snacks.picker.matcher.Config
      matcher = {
        fuzzy = true, -- use fuzzy matching
        smartcase = true, -- use smartcase
        ignorecase = true, -- use ignorecase
        sort_empty = false, -- sort results when the search string is empty
        filename_bonus = true, -- give bonus for matching file names (last part of the path)
        file_pos = true, -- support patterns like `file:line:col` and `file:line`
        -- the bonusses below, possibly require string concatenation and path normalization,
        -- so this can have a performance impact for large lists and increase memory usage
        cwd_bonus = false, -- give bonus for matching files in the cwd
        frecency = false, -- frecency bonus
        history_bonus = false, -- give more weight to chronological order
      },
      win = {
        -- input window
        input = {
          keys = {
            -- NOTE: done
            ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
            ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
            ["<c-f>"] = { "toggle_follow", mode = { "i", "n" } },
            ["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<c-i>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["<c-m>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<c-a>"] = { "select_all", mode = { "n", "i" } },
            ["<c-g>"] = { "toggle_live", mode = { "i", "n" } }, -- pretty cool, can add two arguments to the grep
            ["/"] = "toggle_focus",
            ["<Esc>"] = "cancel",
            ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-q>"] = { "qflist", mode = { "i", "n" } },
            ["<c-n>"] = { "history_forward", mode = { "i", "n" } },
            ["<c-p>"] = { "history_back", mode = { "i", "n" } },
            ["?"] = "toggle_help_input",
            ["s"] = { "edit_split", mode = { "n" } },
            ["v"] = { "edit_vsplit", mode = { "n" } },
            ["G"] = "list_bottom",
            ["gg"] = "list_top",
            ["k"] = "list_down",
            ["l"] = "list_up",
            ["<c-k>"] = { "list_down", mode = { "i", "n" } },
            ["<c-l>"] = { "list_up", mode = { "i", "n" } },
            ["q"] = "close",
          },
        },
        -- preview window
        preview = {
          keys = {
            ["<Esc>"] = "cancel",
            ["q"] = "close",
            ["i"] = "focus_input",
            ["<a-w>"] = "cycle_win",
          },
        },
      },
    },
  },
  keys = {
    -- Top Pickers & Explorer
    -- stylua: ignore start
    { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status({on_show = function () vim.cmd.stopinsert() end}) end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    { "<leader>sG", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { "<leader>so", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>sP", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>sp", function() Snacks.picker.spelling() end, desc = "Spelling" },
    { "<leader>sy", function() Snacks.picker.yanky() end, desc = "Yanks" },
    { "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files" },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>ss", function() Snacks.picker.pickers() end, desc = "Pickers" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader><leader>", function() Snacks.picker.buffers({ on_show = function() vim.cmd.stopinsert() end}) end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
  },
}
