-- Local replacement for the `Util` global utility module.
-- Vendored from LazyVim so the config no longer depends on the LazyVim distro.
-- Submodules (root, pick, cmp, config) load lazily via the metatable below.
-- Generic helpers (warn/error/info/norm) proxy to lazy.core.util, which ships
-- with lazy.nvim and survives the Util removal.
local LazyUtil = require("lazy.core.util")

local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    t[k] = require("util." .. k)
    return t[k]
  end,
})

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

-- Resolved (merged) opts for a plugin spec. Vendored from LazyVim util.
---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  return require("lazy.core.plugin").values(plugin, "opts", false)
end

-- Dedup a list, preserving order. Vendored from LazyVim util.
function M.dedup(list)
  local ret, seen = {}, {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

-- Run fn on the VeryLazy user event. Vendored from LazyVim util.
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

-- Set a local option to `value` only if it hasn't been overridden away from the
-- global default (so we never clobber a user/plugin choice). Returns whether set.
-- Lean stand-in for LazyVim's set_default.
---@param option string
---@param value any
---@return boolean was_set
function M.set_default(option, value)
  local cur = vim.api.nvim_get_option_value(option, { scope = "local" })
  local glob = vim.api.nvim_get_option_value(option, { scope = "global" })
  if cur == glob and cur ~= value then
    vim.api.nvim_set_option_value(option, value, { scope = "local" })
    return true
  end
  return false
end

-- Deprecation warning. Vendored (simplified) from LazyVim util.
function M.deprecate(old, new)
  M.warn(("`%s` is deprecated. Please use `%s` instead"):format(old, new), { title = "config", once = true })
end

-- Statuscolumn (used by the `statuscolumn` option). Delegates to Snacks when loaded.
-- Vendored from LazyVim util.
function M.statuscolumn()
  return package.loaded.snacks and require("snacks.statuscolumn").get() or ""
end

-- Memoize a function on its (inspected) arguments. Vendored from LazyVim util.
local cache = {} ---@type table<(fun()), table<string, any>>
function M.memoize(fn)
  return function(...)
    local key = vim.inspect({ ... })
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end

-- list_extend into a nested key (dotted path) of a table. Vendored from LazyVim util.
function M.extend(t, key, values)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    t[k] = t[k] or {}
    if type(t) ~= "table" then
      return
    end
    t = t[k]
  end
  return vim.list_extend(t, values)
end

-- Resolve a path inside a Mason package install dir. Vendored from LazyVim util.
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = vim.fs.normalize(root .. "/packages/" .. pkg .. "/" .. path)
  if opts.warn then
    vim.schedule(function()
      if not require("lazy.core.config").headless() and not vim.uv.fs_stat(ret) then
        M.warn(
          ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(
            pkg,
            path
          )
        )
      end
    end)
  end
  return ret
end

-- Set a keymap unless a lazy.nvim `keys` handler already owns the lhs.
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  local modes = type(mode) == "string" and { mode } or mode

  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    Snacks.keymap.set(modes, lhs, rhs, opts)
  end
end

return M
