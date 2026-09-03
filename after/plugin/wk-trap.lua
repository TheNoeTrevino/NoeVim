-- Temporary diagnostic for the intermittent <leader>w failure.
-- Delete this file to remove every part of the trap.
--
-- It polls the which-key node for <leader>w. When the node loses its
-- children, the trap writes a dump with the last 300 keys you pressed.
--
--   :WkTrap    dump the current state on demand
--   log file   stdpath("state")/wk-trap.log

local LOG = vim.fn.stdpath("state") .. "/wk-trap.log"
local KEEP = 300

local ring = {}
local ring_n = 0
local healthy = nil

local function write(msg)
  local fd = io.open(LOG, "a")
  if not fd then
    return
  end
  fd:write(msg)
  fd:close()
end

local ns = vim.api.nvim_create_namespace("wk_trap")
vim.on_key(function(key, typed)
  ring_n = ring_n + 1
  ring[(ring_n - 1) % KEEP + 1] = {
    t = vim.uv.hrtime() / 1e6,
    n = ring_n,
    key = vim.fn.keytrans(key or ""),
    typed = vim.fn.keytrans(typed or ""),
    mode = vim.fn.mode(1),
  }
end, ns)

local function recent()
  local out = {}
  for i = 1, KEEP do
    local e = ring[(ring_n + i - 1) % KEEP + 1]
    if e then
      out[#out + 1] = ("%12.0f #%d %-10s <- %-10s mode=%s"):format(e.t, e.n, e.typed, e.key, e.mode)
    end
  end
  return table.concat(out, "\n")
end

-- Reads the which-key cache. It never creates or refreshes a node, so it
-- cannot hide the failure it is looking for.
local function probe()
  local ok, Buf = pcall(require, "which-key.buf")
  if not ok then
    return { stage = "no-module" }
  end

  local buf = vim.api.nvim_get_current_buf()
  local info = {
    stage = "ok",
    buf = buf,
    ft = vim.bo[buf].filetype,
    bt = vim.bo[buf].buftype,
    mode = vim.fn.mode(1),
    trigger = vim.fn.maparg(" ", "n"),
    cached_bufs = vim.tbl_count(Buf.bufs),
  }

  local b = Buf.bufs[buf]
  if not b then
    info.stage = "no-buffer-cache"
    return info
  end

  local m = b.modes["n"]
  if not m then
    info.stage = "no-mode-cache"
    return info
  end

  local found, node = pcall(function()
    return m.tree:find({ " ", "w" }, { expand = true })
  end)
  if not found then
    info.stage = "find-error"
    info.err = tostring(node)
    return info
  end
  if not node then
    info.stage = "no-node"
    return info
  end

  info.is_proxy = node:is_proxy() and true or false
  info.can_expand = node:can_expand() and true or false

  local expanded, children = pcall(function()
    return node:expand()
  end)
  if not expanded then
    info.stage = "expand-error"
    info.err = tostring(children)
    return info
  end

  info.children = vim.tbl_count(children)
  info.keys = table.concat(vim.tbl_keys(children), " ")
  if info.children == 0 then
    info.stage = "empty"
  end
  return info
end

local function dump(reason)
  local ok, info = pcall(probe)
  if not ok then
    info = { stage = "probe-crash", err = tostring(info) }
  end
  write(("\n===== %s  %s =====\n%s\n--- last keys ---\n%s\n"):format(reason, os.date("%F %T"), vim.inspect(info), recent()))
end

vim.api.nvim_create_user_command("WkTrap", function()
  dump("manual")
  vim.notify("wk-trap wrote " .. LOG)
end, { desc = "Dump which-key <leader>w state" })

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local timer = vim.uv.new_timer()
    timer:start(
      3000,
      3000,
      vim.schedule_wrap(function()
        local ok, info = pcall(probe)
        if not ok then
          return
        end
        local now = info.stage == "ok"
        if healthy == true and now == false then
          dump("BROKE: " .. info.stage)
          vim.notify("wk-trap caught it: " .. info.stage, vim.log.levels.WARN)
        end
        healthy = now
      end)
    )
  end,
})
