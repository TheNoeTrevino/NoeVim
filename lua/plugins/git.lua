---@diagnostic disable: missing-fields
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "UIEnter",
    opts = {
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 300,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

      -- stylua: ignore start
      -- Navigation
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")
      map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
      map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
      -- Staging
      map({ "n", "v" }, "<leader>gsh", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map("n", "<leader>gsb", gs.stage_buffer, "Stage Buffer")
      -- Stage Undo
      map("n", "<leader>gsuh", gs.undo_stage_hunk, "Undo Stage Hunk")
      -- Reset
      map({ "n", "v" }, "<leader>grh", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>grb", gs.reset_buffer, "Reset Buffer")
      -- Preview
      map("n", "<leader>gpi", gs.preview_hunk_inline, "Preview Hunk Inline")
      map("n", "<leader>gpf", "<cmd>Gitsigns preview_hunk<CR>", "Preview Hunk Float")
      -- Git blame
      map("n", "<leader>gbl", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<leader>gbt", "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle Blame Line")
      map("n", "<leader>gbb", function() gs.blame() end, "Blame Buffer")
      -- Git diff
      map("n", "<leader>gdo", '<cmd>DiffviewOpen<CR>', "Diff Open")
      map("n", "<leader>gdc", '<cmd>DiffviewClose<CR>', "Diff Close")

      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      map("n", "gm", ":MessengerShow<CR>", "Commit Message")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    config = function()
      local actions = require("diffview.actions")
      require("diffview").setup({
        keymaps = {
          disable_defaults = false, -- Disable the default keymaps
          file_panel = {
            {
              "n",
              "k",
              actions.next_entry,
              { desc = "Bring the cursor to the next file entry" },
            },
            {
              "n",
              "l",
              actions.prev_entry,
              { desc = "Bring the cursor to the previous file entry" },
            },
            {
              "n",
              ";",
              actions.select_entry,
              { desc = "Open the diff for the selected entry" },
            },
          },
        },
      })
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = "UIEnter",
    version = "*",
    config = function()
      require("git-conflict").setup({
        default_mappings = {
          ours = "co",
          theirs = "ct",
          none = "c0",
          both = "cb",
          next = "cn",
          prev = "cp",
        },
        default_commands = true, -- disable commands created by this plugin
        disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
        list_opener = "copen", -- command or function to open the conflicts list
        highlights = { -- They must have background color, otherwise the default color will be used
          incoming = "DiffAdd",
          current = "DiffText",
        },
      })
    end,
  },
  {
    "isakbm/gitgraph.nvim",
    event = "VeryLazy",
    opts = {
      symbols = {
        merge_commit = "",
        commit = "",
        merge_commit_end = "",
        commit_end = "",

        -- Advanced symbols
        GVER = "",
        GHOR = "",
        GCLD = "",
        GCRD = "╭",
        GCLU = "",
        GCRU = "",
        GLRU = "",
        GLRD = "",
        GLUD = "",
        GRUD = "",
        GFORKU = "",
        GFORKD = "",
        GRUDCD = "",
        GRUDCU = "",
        GLUDCD = "",
        GLUDCU = "",
        GLRDCL = "",
        GLRDCR = "",
        GLRUCL = "",
        GLRUCR = "",
      },
      format = {
        timestamp = "%H:%M:%S %d-%m-%Y",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        -- Check diff of a commit
        on_select_commit = function(commit)
          vim.notify("DiffviewOpen " .. commit.hash .. "^!")
          vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
          vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
    keys = {
      {
        "<leader>gG",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
  },
  {
    "yujinyuz/gitpad.nvim",
    config = function()
      require("gitpad").setup({
        title = "GitPad", -- The title of the floating window
        dir = vim.fn.stdpath("data") .. "/gitpad", -- The directory where the notes are stored. Possible value is a valid path ie '~/notes'
        default_text = "", -- Leave this nil if you want to use the default text
        on_attach = function(bufnr)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<Cmd>wq<CR>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<esc>", "<Cmd>wq<CR>", { noremap = true, silent = true })
        end,
      })
    end,
    keys = {
      {
        "<leader>np",
        function()
          require("gitpad").toggle_gitpad() -- or require('gitpad').toggle_gitpad({ title = 'Project notes' })
        end,
        desc = "Gitpad Project",
      },
      {
        "<leader>nb",
        function()
          require("gitpad").toggle_gitpad_branch() -- or require('gitpad').toggle_gitpad_branch({ title = 'Branch notes' })
        end,
        desc = "Gitpad Branch",
      },
      {
        "<leader>nvs",
        function()
          require("gitpad").toggle_gitpad_branch({ window_type = "split", split_win_opts = { split = "right" } })
        end,
        desc = "Gitpad Branch VSplit",
      },

      -- Daily notes
      {
        "<leader>nd",
        function()
          local date_filename = "daily-" .. os.date("%Y-%m-%d.md")
          require("gitpad").toggle_gitpad({ filename = date_filename }) -- or require('gitpad').toggle_gitpad({ filename = date_filename, title = 'Daily notes' })
        end,
        desc = "Gitpad Daily",
      },
      -- Per file notes
      {
        "<leader>nf",
        function()
          local filename = vim.fn.expand("%:p") -- or just use vim.fn.bufname()
          if filename == "" then
            vim.notify("empty bufname")
            return
          end
          filename = vim.fn.pathshorten(filename, 2) .. ".md"
          require("gitpad").toggle_gitpad({ filename = filename }) -- or require('gitpad').toggle_gitpad({ filename = filename, title = 'Current file notes' })
        end,
        desc = "Gitpad File",
      },
    },
  },
}
