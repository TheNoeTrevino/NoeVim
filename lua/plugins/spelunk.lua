return {
  "EvWilson/spelunk.nvim",
  opts = {
    base_mappings = {
      -- Toggle the UI open/closed
      toggle = "<leader>bt",
      -- Add a bookmark to the current stack
      add = "<leader>ba",
      -- Delete current line's bookmark from the current stack
      delete = "<leader>bd",
      -- Move to the next bookmark in the stack
      next_bookmark = "<leader>bn",
      -- Move to the previous bookmark in the stack
      prev_bookmark = "<leader>bp",
      -- Fuzzy-find all bookmarks
      search_bookmarks = "<leader>bf",
      -- Fuzzy-find bookmarks in current stack
      search_current_bookmarks = "<leader>bc",
      -- Fuzzy find all stacks
      search_stacks = "<leader>bs",
      -- Change line of hovered bookmark
      change_line = "<leader>bl",
    },
    window_mappings = {
      -- Move the UI cursor down
      cursor_down = "k",
      -- Move the UI cursor up
      cursor_up = "l",
      -- Move the current bookmark down in the stack
      bookmark_down = "<C-k>",
      -- Move the current bookmark up in the stack
      bookmark_up = "<C-l>",
      -- Jump to the selected bookmark
      goto_bookmark = "<CR>",
      -- Jump to the selected bookmark in a new vertical split
      goto_bookmark_hsplit = "s",
      -- Jump to the selected bookmark in a new horizontal split
      goto_bookmark_vsplit = "v",
      -- Change line of selected bookmark
      change_line = ";",
      -- Delete the selected bookmark
      delete_bookmark = "d",
      -- Navigate to the next stack
      next_stack = "<Tab>",
      -- Navigate to the previous stack
      previous_stack = "<S-Tab>",
      -- Create a new stack
      new_stack = "n",
      -- Delete the current stack
      delete_stack = "D",
      -- Rename the current stack
      edit_stack = "E",
      -- Close the UI
      close = { "q", "<esc>" },
      -- Open the help menu
      help = "h",
    },
    -- Flag to enable directory-scoped bookmark persistence
    enable_persist = true,
    -- Prefix for the Lualine integration
    -- (Change this if your terminal emulator lacks emoji support)
    statusline_prefix = "",
    -- Set UI orientation
    -- Advanced customization: you may set your own layout provider for fine-grained control over layout
    -- See `layout.lua` for guidance on setting this up
    ---@type 'vertical' | 'horizontal'
    orientation = "vertical",
    -- Enable to show bookmark index in status column
    enable_status_col_display = true,
    -- The character rendered before the currently selected bookmark in the UI
    cursor_character = ">",
    -- Set whether or not to persist bookmarks per git branch
    persist_by_git_branch = true,
    -- Optional provider to use to power fuzzy searching capabilities
    -- This can also be explicitly disabled
    ---@type 'telescope' | 'snacks' | 'fzf-lua' | 'disabled'
    fuzzy_search_provider = "snacks",
  },
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    require("spelunk").filename_formatter = function(abspath)
      return vim.fn.fnamemodify(abspath, ":t")
    end
  end,
}
