return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.4",
  dependencies = {
    "ThePrimeagen/harpoon",
    "nvim-lua/plenary.nvim",
    "joshmedeski/telescope-smart-goto.nvim",
  },
  config = function()
    -- Keybindings for Telescope
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>su", "<cmd>Telescope undo<cr>", { desc = "[T]oggle [U]ndotree" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
        layout_config = { width = 0.7 },
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    local telescope = require("telescope")
    local telescopeConfig = require("telescope.config")

    -- Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

    -- I want to search in hidden/dot files.
    table.insert(vimgrep_arguments, "--hidden")
    -- I don't want to search in the `.git` directory.
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*")

    local actions = require("telescope.actions")

    local select_one_or_multi = function(prompt_bufnr)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        require("telescope.actions").close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then
            vim.cmd(string.format("%s %s", "edit", j.path))
          end
        end
      else
        require("telescope.actions").select_default(prompt_bufnr)
      end
    end

    telescope.setup({
      defaults = {
        -- `hidden = true` is not supported in text grep commands.
        vimgrep_arguments = vimgrep_arguments,
        path_display = {
          "filename_first",
        },
        mappings = {
          n = {
            ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          i = {
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<CR>"] = select_one_or_multi,
            ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-S-d>"] = actions.delete_buffer,
            ["<C-s>"] = actions.cycle_previewers_next,
            ["<C-a>"] = actions.cycle_previewers_prev,
            ["<C-d>"] = function(bufnr)
              require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = nil
              return require("telescope.actions").preview_scrolling_down(bufnr)
            end,
            ["<C-u>"] = function(bufnr)
              require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = nil
              return require("telescope.actions").preview_scrolling_up(bufnr)
            end,
            ["<C-e>"] = function(bufnr)
              require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
              return require("telescope.actions").preview_scrolling_down(bufnr)
            end,
            ["<C-y>"] = function(bufnr)
              require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
              return require("telescope.actions").preview_scrolling_up(bufnr)
            end,
          },
        },
      },
      pickers = {
        find_files = {
          -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      },
      extensions = {
        undo = {
          use_delta = true,
          use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
          side_by_side = false,
          vim_diff_opts = { ctxlen = vim.o.scrolloff },
          entry_format = "state #$ID, $STAT, $TIME",
          mappings = {
            i = {
              ["<C-cr>"] = require("telescope-undo.actions").yank_additions,
              ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
              ["<cr>"] = require("telescope-undo.actions").restore,
            },
          },
        },
      },
    })

    require("telescope").load_extension("ui-select")
    vim.g.zoxide_use_select = true

    require("telescope").load_extension("undo")

    require("telescope").load_extension("advanced_git_search")

    require("telescope").load_extension("live_grep_args")

    require("telescope").load_extension("colors")

    require("telescope").load_extension("noice")
  end,
}
