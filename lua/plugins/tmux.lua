return {
  "TheNoeTrevino/vim-tmux-navigator",
  branch = "jkl;-mappings",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-j>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-;>", "<cmd><C-U>TmuxNavigateRight<cr>" },
  },
}
