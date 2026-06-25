-- Neo-tree file explorer. Single source of truth: the base spec (originally
-- vendored from LazyVim's editor.neo-tree extra) plus the personal overrides.
-- Both entries target the same repo; lazy.nvim deep-merges opts and concatenates
-- keys, so the override entry (last) wins on conflicts.
local Util = require("util")
return {
  -- Base spec
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree")
            end
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },

  -- Personal overrides: float window, custom mappings, skip on Windows.
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = function()
      return vim.loop.os_uname().sysname ~= "Windows_NT"
    end,
    opts = {
      popup_border_style = "single",
      source_selector = {
        winbar = true,
        content_layout = "center", -- only with `tabs_layout` = "equal", "focus"
      },
      window = {
        popup = {
          size = {
            height = "85%",
            width = "50%",
          },
          title = "NoeVim",
        },
        position = "float",
        mappings = {
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          ["s"] = "open_split",
          ["v"] = "open_vsplit",
          ["l"] = "none",
          ["h"] = "none",
          [";"] = "open",
          ["j"] = "close_node",
          ["<space>"] = "none",
          ["f"] = "focus_preview",
          ["<C-u>"] = { "scroll_preview", config = { direction = 10 } },
          ["<C-d>"] = { "scroll_preview", config = { direction = -10 } },
          ["/"] = "none",
          ["<esc>"] = function(state)
            vim.cmd("Neotree toggle")
          end,
        },
      },
    },
    keys = function()
      return {
        { "<leader>e", "<cmd>Neotree reveal_force_cwd toggle<cr>", desc = "Explorer NeoTree (Root Dir)", remap = true },
      }
    end,
  },
}
