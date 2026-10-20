-- Bruno (.bru) support: a hand-registered treesitter parser plus a filetype mapping.
-- tree-sitter-bruno is a grammar repo with no Lua in it, so it is not a lazy.nvim
-- plugin. nvim-treesitter fetches and builds it, same as lang-openscad.lua does.

vim.filetype.add({ extension = { bru = "bruno" } })

-- lazy.nvim keeps only one `init` per plugin, so a second spec's `init` would clobber
-- lang-openscad.lua's. The autocmd goes at file level instead, which runs when the spec
-- files are parsed, before nvim-treesitter loads.
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  group = vim.api.nvim_create_augroup("bruno_treesitter", { clear = true }),
  callback = function()
    require("nvim-treesitter.parsers").bruno = {
      install_info = {
        url = "https://github.com/kristoferssolo/tree-sitter-bruno",
        revision = "c6d42e349353f02ad051dd9c88a38df639ef688f",
        -- Copies the grammar's queries/ (highlights, folds, indents, injections)
        -- next to the parser.
        queries = "queries",
      },
      tier = 2,
    }
  end,
})

return {
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "bruno" } } },
}
