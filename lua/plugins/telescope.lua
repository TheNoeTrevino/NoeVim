return {
  "nvim-telescope/telescope.nvim",

  keys = function()
    return {
      -- git
      { "<leader>gsc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>gss", "<cmd>Telescope git_status<CR>", desc = "Statuses" },
      -- search
      { "<leader>sb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr><esc>", desc = "Buffers" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Grep Current Buffer" },
      { "<leader>si", LazyVim.pick.config_files(), desc = "Search Config" },
      { "<leader>sp", "<cmd>Telescope neoclip<cr><ESC>", desc = "Neoclip" },
      { "<leader>sc", "<cmd>Telescope command_history<cr><esc>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep" },
      { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep - cwd" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>so", "<cmd>Telescope oldfiles<cr><esc>", desc = "Recent Files" },
      { "<leader>sr", "<cmd>Telescope resume<cr><esc>", desc = "Resume" },
      { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
      { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "Searchs" },
      { "<leader>sw", LazyVim.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
      { "<leader>sW", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
      { "<leader>uC", LazyVim.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },
      { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Files" },
      { "<leader>su", "<cmd>Telescope undo<cr><esc>", desc = "Undo" },
      { "<leader>s'", "<cmd>Telescope macroscope<cr><esc>", desc = "Macros" },
      { "<leader>s;", LazyVim.pick.config_files(), desc = "Config" },
      { "<leader>cd", "<cmd>Telescope zoxide list<cr><esc>", desc = "Zoxide" },
      {
        "<leader>sm",
        "<cmd>Telescope marks<cr><esc>",
        mode = { "n" },
        desc = "Marks",
      },
      {
        "<leader>sj",
        "<cmd>Telescope jumplist layout_strategy=vertical layout_config={preview_height=0.7} sort_mru=true sort_lastused=true<cr><esc>",
        mode = { "n" },
        desc = "Jumps",
      },
      {
        "<leader>sy",
        "<cmd>Telescope yank_history layout_strategy=vertical layout_config={preview_height=0.6} sort_mru=true sort_lastused=true<cr><esc>",
        mode = { "n" },
        desc = "Yanks",
      },
      {
        "<leader>sn",
        function()
          require("telescope.builtin").find_files({ cwd = "~/notes/" })
        end,
        desc = "Notes",
      },
      {
        "<leader><leader>",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr><esc>",
        desc = "Buffers",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = LazyVim.config.get_kind_filter(),
          })
        end,
        desc = "Goto Symbol",
      },
    }
  end,
  opts = function()
    local actions = require("telescope.actions")
    require("telescope").load_extension("zoxide")
    local open_with_trouble = function(...)
      return require("trouble.sources.telescope").open(...)
    end
    local find_files_no_ignore = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      LazyVim.pick("find_files", { no_ignore = true, default_text = line, file_ignore_patterns = {} })()
    end
    local find_files_with_hidden = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      LazyVim.pick("find_files", { hidden = true, default_text = line })()
    end

    local path_actions = require("telescope_insert_path")

    return {
      defaults = {
        path_display = { "smart" },
        layout_config = {
          width = 0.85, -- Adjust the overall width of Telescope (e.g., 80% of the screen)
          preview_cutoff = 40, -- Set the preview width to 40 columns when the window is less than 40 columns
          horizontal = {
            preview_width = 0.666, -- Adjust the preview window to 60% of the Telescope window's width
          },
        },
        file_ignore_patterns = {
          "^env/.*",
          "%.env",
          "node_modules",
          "node_modules/",
          "%.git",
          "%.png",
          "%.jpg",
          "%.jpeg",
          "%.gif",
          "%.bmp",
          "%.tiff",
          "%.svg",
          "%.webp",
          "%.ico",
          "%.heic",
          "%.heif",
          "%.raw",
          "%.raw",
          "__pycache__/",
          "%.pyc",
        },
        prompt_prefix = " ",
        selection_caret = " ",
        -- open files in the first window that is an actual file.
        -- use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
        mappings = {
          i = {
            ["<C-t>"] = open_with_trouble,
            ["<C-i>"] = find_files_no_ignore,
            ["<C-h>"] = find_files_with_hidden,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-r>"] = path_actions.insert_reltobufpath_a_normal,
          },
          n = {
            ["d"] = actions.delete_buffer,
            ["t"] = actions.file_tab,
            ["v"] = actions.file_vsplit,
            ["s"] = actions.file_split,
            ["l"] = actions.move_selection_previous,
            ["k"] = actions.move_selection_next,
            ["q"] = actions.close,
            ["<leader>r"] = path_actions.insert_reltobufpath_a_normal,
          },
        },
      },
    }
  end,
}
