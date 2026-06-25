-- Vendored from the LazyVim distro (lazyvim/util/cmp.lua), trimmed to the snippet actions
-- this config uses (Util.cmp.actions.snippet_stop in <esc> mapping).
local M = {}

M.actions = {
  snippet_forward = function()
    if vim.snippet.active({ direction = 1 }) then
      vim.schedule(function()
        vim.snippet.jump(1)
      end)
      return true
    end
  end,
  snippet_stop = function()
    if vim.snippet then
      vim.snippet.stop()
    end
  end,
}

return M
