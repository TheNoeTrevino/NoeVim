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
        preset = "vertical",
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
        preset = "vertical",
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
  "folke/snacks.nvim",
  opts = {
    indent = { enabled = false },
    statuscolumn = { enabled = false },
    dashboard = { enabled = false },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 80 },
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
      layout = {
        cycle = true,
        --- Use the default layout or vertical if the window is too narrow
        reverse = true,
        layout = {
          box = "horizontal",
          backdrop = false,
          width = 0.9,
          height = 0.9,
          border = "none",
          {
            box = "vertical",
            { win = "list", title = " Results ", title_pos = "center", border = true },
            { win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
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
      win = {
        -- input window
        input = {
          keys = {
            -- NOTE: done
            ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
            ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
            ["<c-f>"] = { "toggle_follow", mode = { "i", "n" } },
            ["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<c-i>"] = { "toggle_ignore", mode = { "i", "n" } },
            ["I"] = { "toggle_ignore", mode = { "n" } },
            ["H"] = { "toggle_hidden", mode = { "n" } },
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
  keys = {
    -- Top Pickers & Explorer
    -- stylua: ignore start
    -- { "<leader>,", function() Snacks.picker.buffers({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>N", function() Snacks.picker.notifications() end, desc = "Notification History" },
    -- Git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Git Status" },
    { "H", function() Snacks.picker.git_status({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    { "<leader>sG", grep_directory, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.git_grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { "<leader>sr", function() Snacks.picker.recent({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Recent" },
    { "<leader>sP", "<CMD>lua Snacks.picker.projects( { layout = { preview = false, reverse = false, layout = { backdrop = false, row = 1, width = 0.4, min_width = 80, height = 0.4, border = 'none', box = 'vertical', { win = 'input', height = 1, border = 'single', title = '{title} {live} {flags}', title_pos = 'center' }, { win = 'list', border = 'single' }, { win = 'preview', title = '{preview}', border = 'rounded' }, }, }, on_show = function() vim.cmd.stopinsert() end, })<CR>", desc = "Projects" },
    { "<leader>sp", "<CMD>lua Snacks.picker.spelling( { layout = { preview = false, reverse = false, layout = { backdrop = false, row = 1, width = 0.4, min_width = 80, height = 0.4, border = 'none', box = 'vertical', { win = 'input', height = 1, border = 'single', title = '{title} {live} {flags}', title_pos = 'center' }, { win = 'list', border = 'single' }, { win = 'preview', title = '{preview}', border = 'rounded' }, }, }, on_show = function() vim.cmd.stopinsert() end, })<CR>", desc = "Spelling" },
    { "<leader>sy", function() Snacks.picker.yanky() end, desc = "Yanks" },
    { "<leader>sf", function() Snacks.picker.git_files() end, desc = "Find Files" },
    { "<leader>sF", search_file_directory, "Search: Directory" },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>sj", "<CMD>lua Snacks.picker.jumps({on_show = function() vim.cmd.stopinsert() end, layout = {preview = true,layout = {box = 'vertical',backdrop = false,row = -1,width = 0,height = 0.33,border = 'top',title = ' {title} {live} {flags}',title_pos = 'left',{ win = 'input', height = 1, border = 'bottom' },{box = 'horizontal',{ win = 'list', border = 'none' },{ win = 'preview', title = '{preview}', width = 0.7, border = 'left' }, },},},})<CR>", desc = "Jumps" },
    { "<leader>sl", function() Snacks.picker.lsp_config() end, desc = "Location List" },
    { "<leader>sL", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sq", function() Snacks.picker.qflist({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Quickfix List" },
    { "<leader>su", function() Snacks.picker.undo({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Undo History" },
    { "<leader>ss", function() Snacks.picker.pickers() end, desc = "Pickers" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>sb", function() Snacks.picker.buffers({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Buffers" },
    { "<leader>st", "<CMD>lua Snacks.picker.todo_comments({ on_show = function() vim.cmd.stopinsert() end})<CR>", desc = "Todo" },
    { "<leader><leader>", function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, desc = "Lazygit" },
    { "h", function() Snacks.picker.buffers({on_show = function()vim.cmd.stopinsert()end,}) end, desc = "Buffers" },
    -- LSP
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
  },
}
