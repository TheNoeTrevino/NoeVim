return {
  "MattesGroeger/vim-bookmarks",
  init = function()
    vim.g.bookmark_sign = "⚑"
    vim.g.bookmark_highlight_lines = 1

    vim.keymap.set("n", "<Leader>bt", "<Plug>BookmarkToggle")
    vim.keymap.set("n", "<Leader>ba", "<Plug>BookmarkAnnotate")
    vim.keymap.set("n", "<c-p>", "<Plug>BookmarkShowAll")
    vim.keymap.set("n", "<Leader>bk", "<Plug>BookmarkNext")
    vim.keymap.set("n", "<Leader>bl", "<Plug>BookmarkPrev")
    vim.keymap.set("n", "<Leader>bc", "<Plug>BookmarkClear")
    vim.keymap.set("n", "<Leader>bC", "<Plug>BookmarkClearAll")
    vim.keymap.set("n", "<Leader>bL", "<Plug>BookmarkMoveUp")
    vim.keymap.set("n", "<Leader>bK", "<Plug>BookmarkMoveDown")
    vim.keymap.set("n", "<Leader>bg", "<Plug>BookmarkMoveToLine")
  end,
}
