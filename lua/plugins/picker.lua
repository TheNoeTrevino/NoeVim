local explorer_config = function()
  return
  ---@type snacks.picker.explorer.Config
  {
    layout = { preset = "sidebar", preview = true },
    -- to show the explorer to the right, add the below to
    -- your config under `opts.picker.sources.explorer`
    -- layout = { layout = { position = "right" } },
    formatters = {
      file = { filename_only = true },
      severity = { pos = "right" },
    },
    matcher = { sort_empty = false, fuzzy = false },
    config = function(opts)
      return require("snacks.picker.source.explorer").setup(opts)
    end,
    win = {
      list = {
        keys = {
          ["<BS>"] = "explorer_up",
          ["."] = "explorer_focus",
          ["s"] = { "edit_split", mode = { "n" } },
          ["v"] = { "edit_vsplit", mode = { "n" } },
          ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["P"] = "toggle_preview",
          ["f"] = "focus_preview",
          ["<Esc>"] = "close",
          ["q"] = "close",
          ["/"] = "toggle_focus",
          ["a"] = "explorer_add",
          ["d"] = "explorer_del",
          ["r"] = "explorer_rename",
          ["c"] = "explorer_copy",
          ["m"] = "explorer_move",
          ["o"] = "explorer_open",
          ["y"] = { "explorer_yank", mode = { "n", "x" } },
          ["p"] = "explorer_paste",
          ["u"] = "explorer_update",
          ["H"] = "toggle_hidden",
          ["I"] = "toggle_ignore",
          ["?"] = "toggle_help_list",
          ["<c-q>"] = { "qflist", mode = { "i", "n" } },
          ["]g"] = "explorer_git_next",
          ["[g"] = "explorer_git_prev",
          ["]d"] = "explorer_diagnostic_next",
          ["[d"] = "explorer_diagnostic_prev",
          ["k"] = "list_down",
          ["l"] = "list_up",
          ["j"] = "explorer_close", -- close directory (like neotree j)
          [";"] = { "confirm", mode = { "n" } },
        },
      },
      -- input window
      input = {
        keys = {
          ["<Esc>"] = "close",
          ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["/"] = "toggle_focus",
        },
      },
      -- preview window
      preview = {
        keys = {
          ["<Esc>"] = "close",
          ["q"] = "close",
          ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["f"] = "focus_input",
        },
      },
    },
  }
end
local get_config = function()
  return {
    layout = {
      cycle = true,
      --- Use the default layout or vertical if the window is too narrow
      reverse = true,
      layout = {
        box = "horizontal",
        backdrop = true,
        width = 0,
        height = 0,
        border = "none",
        {
          box = "vertical",
          { win = "list", title = " Results ", title_pos = "center", border = true },
          {
            win = "input",
            height = 1,
            border = true,
            title = "{title} {live} {flags}",
            title_pos = "center",
          },
        },
        {
          win = "preview",
          title = "{preview:Preview}",
          width = 0.6,
          border = true,
          title_pos = "center",
        },
      },
      --   function()
      --   return vim.o.columns >= 120 and "default" or "vertical"
      -- end,
    },
  }
end

local config_get_symbols = function()
  return { layout = { preset = "vscode", preview = "main" } }
end

local get_spelling = function()
  return {
    layout = {
      preview = false,
      reverse = false,
      layout = {
        backdrop = true,
        row = 1,
        width = 0.4,
        min_width = 80,
        height = 0.4,
        border = "none",
        box = "vertical",
        { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
        { win = "list", border = "single" },
        { win = "preview", title = "{preview}", border = "rounded" },
      },
    },
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end

local get_dir_select = function()
  return {
    layout = {
      preview = false,
      reverse = false,
      layout = {
        backdrop = true,
        row = 1,
        width = 0.4,
        min_width = 80,
        height = 0.4,
        border = "none",
        box = "vertical",
        { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
        { win = "list", border = "single" },
        { win = "preview", title = "{preview}", border = "rounded" },
      },
    },
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end

local get_jumplist = function()
  return {
    on_show = function()
      vim.cmd.stopinsert()
    end,
    layout = {
      preview = true,
      layout = {
        box = "vertical",
        backdrop = true,
        row = -1,
        width = 0,
        height = 0.33,
        border = "top",
        title = " {title} {live} {flags}",
        title_pos = "left",
        { win = "input", height = 1, border = "bottom" },
        {
          box = "horizontal",
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", width = 0.7, border = "left" },
        },
      },
    },
  }
end

local get_config_colorschemes = function()
  return {
    finder = "vim_colorschemes",
    format = "text",
    preview = "colorscheme",
    preset = "vertical",
    confirm = function(picker, item)
      picker:close()
      if item then
        picker.preview.state.colorscheme = nil
        vim.schedule(function()
          vim.cmd("colorscheme " .. item.text)
        end)
      end
    end,
  }
end

local get_config_nm = function()
  return {
    on_show = function()
      vim.cmd.stopinsert()
    end,
    layout = {
      cycle = true,
      --- Use the default layout or vertical if the window is too narrow
      reverse = true,
      layout = {
        box = "horizontal",
        backdrop = true,
        width = 0,
        height = 0,
        border = "none",
        {
          box = "vertical",
          { win = "list", title = " Results ", title_pos = "center", border = true },
          {
            win = "input",
            height = 1,
            border = true,
            title = "{title} {live} {flags}",
            title_pos = "center",
          },
        },
        {
          win = "preview",
          title = "{preview:Preview}",
          width = 0.6,
          border = true,
          title_pos = "center",
        },
      },
      --   function()
      --   return vim.o.columns >= 120 and "default" or "vertical"
      -- end,
    },
  }
end

local get_config_vert = function()
  return {
    layout = {
      cycle = true,
      --- Use the default layout or vertical if the window is too narrow
      preset = function()
        return vim.o.columns >= 120 and "default" or "vertical"
      end,
    },
  }
end

-- TODO: extract this lol
local grep_directory = function()
  local snacks = require("snacks")
  local has_fd = vim.fn.executable("fd") == 1
  local cwd = vim.fn.getcwd()

  local function show_picker(dirs)
    if #dirs == 0 then
      vim.notify("No directories found", vim.log.levels.WARN)
      return
    end

    local items = {}
    for i, item in ipairs(dirs) do
      table.insert(items, {
        idx = i,
        file = item,
        text = item,
      })
    end

    snacks.picker({
      confirm = function(picker, item)
        picker:close()
        snacks.picker.grep({
          dirs = { item.file },
        })
      end,
      items = items,
      format = function(item, _)
        local file = item.file
        local ret = {}
        local a = Snacks.picker.util.align
        local icon, icon_hl = Snacks.util.icon(file.ft, "directory")
        ret[#ret + 1] = { a(icon, 3), icon_hl }
        ret[#ret + 1] = { " " }
        local path = file:gsub("^" .. vim.pesc(cwd) .. "/", "")
        ret[#ret + 1] = { a(path, 20), "Directory" }

        return ret
      end,
      layout = {
        preview = false,
        reverse = false,
        layout = {
          backdrop = true,
          row = 1,
          width = 0.4,
          min_width = 80,
          height = 0.4,
          border = "none",
          box = "vertical",
          { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
          { win = "list", border = "single" },
          { win = "preview", title = "{preview}", border = "rounded" },
        },
      },
      title = "Grep in Directory",
    })
  end

  if has_fd then
    local cmd = { "fd", "--type", "directory", "--hidden", "--no-ignore-vcs", "--exclude", ".git" }
    local dirs = {}

    vim.fn.jobstart(cmd, {
      on_stdout = function(_, data, _)
        for _, line in ipairs(data) do
          if line and line ~= "" then
            table.insert(dirs, line)
          end
        end
      end,
      on_exit = function(_, code, _)
        if code == 0 then
          show_picker(dirs)
        else
          -- Fallback to plenary if fd fails
          local fallback_dirs = require("plenary.scandir").scan_dir(cwd, {
            only_dirs = true,
            respect_gitignore = true,
          })
          show_picker(fallback_dirs)
        end
      end,
    })
  else
    -- Use plenary if fd is not available
    local dirs = require("plenary.scandir").scan_dir(cwd, {
      only_dirs = true,
      respect_gitignore = true,
    })
    show_picker(dirs)
  end
end

local search_file_directory = function()
  local snacks = require("snacks")
  local has_fd = vim.fn.executable("fd") == 1
  local cwd = vim.fn.getcwd()

  local function show_picker(dirs)
    if #dirs == 0 then
      vim.notify("No directories found", vim.log.levels.WARN)
      return
    end

    local items = {}
    for i, item in ipairs(dirs) do
      table.insert(items, {
        idx = i,
        file = item,
        text = item,
      })
    end

    snacks.picker({
      confirm = function(picker, item)
        picker:close()
        snacks.picker.files({
          dirs = { item.file },
        })
      end,
      items = items,
      format = function(item, _)
        local file = item.file
        local ret = {}
        local a = Snacks.picker.util.align
        local icon, icon_hl = Snacks.util.icon(file.ft, "directory")
        ret[#ret + 1] = { a(icon, 3), icon_hl }
        ret[#ret + 1] = { " " }
        local path = file:gsub("^" .. vim.pesc(cwd) .. "/", "")
        ret[#ret + 1] = { a(path, 20), "Directory" }

        return ret
      end,
      layout = {
        preview = false,
        reverse = false,
        layout = {
          backdrop = true,
          row = 1,
          width = 0.4,
          min_width = 80,
          height = 0.4,
          border = "none",
          box = "vertical",
          { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
          { win = "list", border = "single" },
          { win = "preview", title = "{preview}", border = "rounded" },
        },
      },
      title = "Search Files in Directory",
    })
  end

  if has_fd then
    local cmd = { "fd", "--type", "directory", "--hidden", "--no-ignore-vcs", "--exclude", ".git" }
    local dirs = {}

    vim.fn.jobstart(cmd, {
      on_stdout = function(_, data, _)
        for _, line in ipairs(data) do
          if line and line ~= "" then
            table.insert(dirs, line)
          end
        end
      end,
      on_exit = function(_, code, _)
        if code == 0 then
          show_picker(dirs)
        else
          -- Fallback to plenary if fd fails
          local fallback_dirs = require("plenary.scandir").scan_dir(cwd, {
            only_dirs = true,
            respect_gitignore = true,
          })
          show_picker(fallback_dirs)
        end
      end,
    })
  else
    -- Use plenary if fd is not available
    local dirs = require("plenary.scandir").scan_dir(cwd, {
      only_dirs = true,
      respect_gitignore = true,
    })
    show_picker(dirs)
  end
end

return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        layout = {
          preset = "telescope",
        },
        ui_select = true, -- replace `vim.ui.select` with the snacks picker
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
            truncate = 60, -- truncate the file path to (roughly) this length
            git_status_hl = true, -- use the git status highlight group for the filename
          },
        },
        prompt = " ",
        sources = {},
        focus = "input",
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
        actions = {
          sidekick_send = function(...)
            return require("sidekick.cli.picker.snacks").send(...)
          end,
        },
        win = {
          -- input window
          input = {
            keys = {
              ["<c-a>"] = {
                "sidekick_send",
                mode = { "n", "i" },
              },
              ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
              ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
              ["<c-f>"] = { "toggle_follow", mode = { "i", "n" } },
              ["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<c-i>"] = { "toggle_ignore", mode = { "i", "n" } },
              ["I"] = { "toggle_ignore", mode = { "n" } },
              ["H"] = { "toggle_hidden", mode = { "n" } },
              ["<c-m>"] = { "toggle_maximize", mode = { "i", "n" } },
              ["<c-g>"] = { "toggle_live", mode = { "i", "n" } }, -- pretty cool, can add two arguments to the grep
              ["/"] = "toggle_focus",
              ["<Esc>"] = "cancel",
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-q>"] = { "qflist", mode = { "i", "n" } },
              ["<c-n>"] = { "history_forward", mode = { "i", "n" } },
              ["<c-p>"] = { "history_back", mode = { "i", "n" } },
              [";"] = { "confirm", mode = { "n" } },
              ["S"] = { "flash" },
              ["<c-s>"] = { "flash", mode = { "i" } },
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
              ["d"] = "bufdelete",
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
    keys = function()
      -- TODO: hes adding more pickers and i want access to all of them. Can we
      -- start to populate f with  some of the strange keymaps here? keeping files
      -- and grep for s?
      return {
        -- Top Pickers & Explorer
        -- stylua: ignore start
        -- { "<leader>,", function() Snacks.picker.buffers({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Buffers" },
        { "<leader>.",        function() Snacks.scratch() end,                                                      desc = "Toggle Scratch Buffer" },
        { "<leader>e",        function() Snacks.picker.explorer(explorer_config()) end,                             desc = "Explorer" },
        { "<leader>s.",       function() Snacks.scratch.select() end,                                               desc = "Select Scratch Buffer" },
        { "<leader>dps",      function() Snacks.profiler.scratch() end,                                             desc = "Profiler Scratch Buffer" },
        { "<leader>:",        function() Snacks.picker.command_history(get_config()) end,                           desc = "Command History" },
        { "<leader>N",        function() Snacks.picker.notifications(get_config()) end,                             desc = "Notification History" },
        -- Git
        { "<leader>gb",       function() Snacks.picker.git_branches(get_config()) end,                              desc = "Git Branches" },
        { "<leader>gl",       function() Snacks.picker.git_log(get_config()) end,                                   desc = "Git Log" },
        { "<leader>gL",       function() Snacks.picker.git_log_line(get_config()) end,                              desc = "Git Log Line" },
        { "<leader>gs",       function() Snacks.picker.git_status(get_config_nm()) end,                             desc = "Git Status" },
        { "H",                function() Snacks.picker.git_status(get_config_nm()) end,                             desc = "Git Status" },
        { "<leader>gS",       function() Snacks.picker.git_stash(get_config_nm()) end,                              desc = "Git Stash" },
        { "<leader>gd",       function() Snacks.picker.git_diff() end,                                              desc = "Git Diff (Hunks)" },
        { "<leader>gf",       function() Snacks.picker.git_log_file() end,                                          desc = "Git Log File" },
        -- Grep
        { "<leader>sg",       function() Snacks.picker.grep(get_config()) end,                                      desc = "Grep" },
        { "<leader>sG",       function() Snacks.picker.git_grep(get_config()) end,                                  desc = "Grep Git" },
        { "<leader>sw",       function() Snacks.picker.grep_word(get_config()) end,                                 desc = "Visual selection or word", mode = { "n", "x" } },
        -- Search -- movement based
        { "<leader>sr",       function() Snacks.picker.resume(get_config_nm()) end,                                 desc = "Recent" },
        { "<leader>sP",       function () Snacks.picker.projects(get_spelling()) end,                               desc = "Projects" },
        { "<leader>sp",       function () Snacks.picker.spelling(get_spelling()) end,                               desc = "Spelling" },
        { "<leader>sf",       function() Snacks.picker.files(get_config()) end,                                     desc = "Find Files" },
        { "<leader>sF",       function() Snacks.picker.git_files(get_config()) end,                                 desc = "Find Git Files" },
        { '<leader>s/',       function() Snacks.picker.search_history(get_config()) end,                            desc = "Search History" },
        { "<leader>sd",       function() Snacks.picker.diagnostics(get_config()) end,                               desc = "Diagnostics" },
        { "<leader>sD",       function() Snacks.picker.diagnostics_buffer(get_config()) end,                        desc = "Buffer Diagnostics" },
        { "<leader>sc",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,               desc = "Find Config File" },
        { "<leader>sj",       function () Snacks.picker.jumps(get_jumplist())end,                                   desc = "Jumps" },
        { "<leader>sm",       function() Snacks.picker.marks(get_config_nm()) end,                                  desc = "Marks" },
        { "<leader>sq",       function() Snacks.picker.qflist(get_config_nm()) end,                                 desc = "Quickfix List" },
        { "<leader>su",       function() Snacks.picker.undo({ layout = "ivy_split" }) end,                          desc = "Undo History" },
        { "<leader>s?",       function() Snacks.picker.pickers(get_config()) end,                                   desc = "Pickers" },
        { "<leader>sb",       function() Snacks.picker.buffers(get_config_nm()) end,                                desc = "Buffers" },
        { "<leader>st",       function()Snacks.picker.todo_comments(get_config_nm())end,                            desc = "Todo" },
        { "h",                function() Snacks.picker.buffers(get_config_nm()) end,                                desc = "Buffers" },
        -- potential mappings to move to f
        { "<leader>sM",       function() Snacks.picker.man(get_config()) end,                                       desc = "Man Pages" },
        { "<leader>sh",       function() Snacks.picker.help(get_config()) end,                                      desc = "Help Pages" },
        { "<leader>sH",       function() Snacks.picker.highlights(get_config()) end,                                desc = "Highlights" },
        { "<leader>ff",       search_file_directory,                                                                desc = "Select Dir to Search" },
        { "<leader>fg",       grep_directory,                                                                       desc = "Select Dir to Grep" },
        { "<leader>fr",       function() Snacks.picker.recent(get_config_nm()) end,                                 desc = "Recent" },
        { '<leader>s"',       function() Snacks.picker.registers(get_config_nm()) end,                              desc = "Registers" },
        { "<leader>sk",       function() Snacks.picker.keymaps(get_config()) end,                                   desc = "Keymaps" },
        { "<leader>sc",       function() Snacks.picker.command_history(get_config()) end,                           desc = "Command History" },
        { "<leader>sC",       function() Snacks.picker.commands(get_config()) end,                                  desc = "Commands" },
        { "<leader>sy",       function() Snacks.picker.yanky(get_config()) end,                                     desc = "Yanks" },
        -- maybe remove, literally never used once
        -- { "<leader>sL", function() Snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>sa",       function() Snacks.picker.autocmds(get_config()) end,                                  desc = "Autocmds" },
        { "<leader>sI",       function() Snacks.picker.icons(get_config()) end,                                     desc = "Keymaps" },
        -- Random
        { "<leader>bd",       function() Snacks.bufdelete() end,                                                    desc = "Delete Buffer", },
        { "<leader>uC",       function() Snacks.picker.colorschemes(get_config_colorschemes()) end,                 desc = "Colorschemes" },
        { "<leader><leader>", function() Snacks.lazygit({ cwd = LazyVim.root.git() }) end,                          desc = "Lazygit" },
        -- LSP NOTE: maybe move these to l? idk.  also make a vertical layout for these
        { "<leader>sL",       function() Snacks.picker.lsp_config(get_config()) end,                                desc = "LSP Config" },
        { "<leader>slo",      function() Snacks.picker.lsp_outgoing_calls(get_config_vert()) end,                   desc = "LSP Outgoing calls" },
        { "<leader>sli",      function() Snacks.picker.lsp_incoming_calls(get_config_vert()) end,                   desc = "LSP Incoming calls" },
        -- { "<leader>sls",      function() Snacks.picker.lsp_symbols(config_get_symbols()) end,                       desc = "LSP Symbols" },
        -- { "<leader>slS",      function() Snacks.picker.lsp_workspace_symbols(config_get_symbols()) end,             desc = "LSP Symbols" },
        { "gd",               function() Snacks.picker.lsp_definitions(get_config()) end,                           desc = "Goto Definition" },
        { "gD",               function() Snacks.picker.lsp_declarations(get_config()) end,                          desc = "Goto Declaration" },
        { "gr",               function() Snacks.picker.lsp_references(get_config()) end,             nowait = true, desc = "References" },
        { "gI",               function() Snacks.picker.lsp_implementations(get_config()) end,                       desc = "Goto Implementation" },
        { "gy",               function() Snacks.picker.lsp_type_definitions(get_config()) end,                      desc = "Goto T[y]pe Definition" },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- stylua: ignore
          keys = {
            { "gd",  function() Snacks.picker.lsp_definitions(get_config()) end,      desc = "Goto Definition",       has = "definition" },
            { "gr",  function() Snacks.picker.lsp_references(get_config()) end,       nowait = true,                  desc = "References" },
            { "gI",  function() Snacks.picker.lsp_implementations(get_config()) end,  desc = "Goto Implementation" },
            { "gy",  function() Snacks.picker.lsp_type_definitions(get_config()) end, desc = "Goto T[y]pe Definition" },
            -- { "<leader>ss", function() Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Symbols", has = "documentSymbol" },
            -- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Workspace Symbols", has = "workspace/symbols" },
            { "gai", function() Snacks.picker.lsp_incoming_calls(get_config()) end,   desc = "C[a]lls Incoming",      has = "callHierarchy/incomingCalls" },
            { "gao", function() Snacks.picker.lsp_outgoing_calls(get_config()) end,   desc = "C[a]lls Outgoing",      has = "callHierarchy/outgoingCalls" },
            { "]]",  function() Snacks.words.jump(vim.v.count1) end,                  desc = "Next Reference",        mode = { "n", "t" }, },
            { "[[",  function() Snacks.words.jump(-vim.v.count1) end,                 desc = "Prev Reference",        mode = { "n", "t" }, },
          },
        },
      },
    },
  },
}
