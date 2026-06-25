-- Picker abstraction, with the snacks picker registered as the backend.
local Util = require("util")

---@class util.pick
---@overload fun(command:string, opts?:table): fun()
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.wrap(...)
  end,
})

M.picker = nil

function M.register(picker)
  if vim.v.vim_did_enter == 1 then
    return true
  end
  if M.picker and M.picker.name ~= picker.name then
    Util.warn(
      "`Util.pick`: picker already set to `" .. M.picker.name .. "`,\nignoring new picker `" .. picker.name .. "`"
    )
    return false
  end
  M.picker = picker
  return true
end

function M.open(command, opts)
  if not M.picker then
    return Util.error("Util.pick: picker not set")
  end

  command = command ~= "auto" and command or "files"
  opts = opts or {}
  opts = vim.deepcopy(opts)

  if type(opts.cwd) == "boolean" then
    Util.warn("Util.pick: opts.cwd should be a string or nil")
    opts.cwd = nil
  end

  if not opts.cwd and opts.root ~= false then
    opts.cwd = Util.root({ buf = opts.buf })
  end

  command = M.picker.commands[command] or command
  M.picker.open(command, opts)
end

function M.wrap(command, opts)
  opts = opts or {}
  return function()
    M.open(command, vim.deepcopy(opts))
  end
end

function M.config_files()
  return M.wrap("files", { cwd = vim.fn.stdpath("config") })
end

-- The snacks picker backend.
-- Assigned directly rather than via M.register so it's set even when this module
-- is first required after VimEnter (register() early-returns post-startup).
M.picker = {
  name = "snacks",
  commands = {
    files = "files",
    live_grep = "grep",
    oldfiles = "recent",
  },
  open = function(source, opts)
    return Snacks.picker.pick(source, opts)
  end,
}

return M
