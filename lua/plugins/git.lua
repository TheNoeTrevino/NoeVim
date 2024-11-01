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
        on_select_commit = function(commit)
          print("selected commit:", commit.hash)
        end,
        on_select_range_commit = function(from, to)
          print("selected range:", from.hash, to.hash)
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
    "lsig/messenger.nvim",
    event = "VeryLazy",
    opts = {
      border = "rounded",
    },
  },
}
