-- LSP helpers used by lsp-config: formatter (registered with the format subsystem),
-- format, action, execute, code_actions, restart.
local Util = require("util")

---@class util.lsp
local M = {}

---@param opts? LazyFormatter| {filter?: (string|vim.lsp.get_clients.Filter)}
function M.formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  ---@cast filter vim.lsp.get_clients.Filter
  ---@type LazyFormatter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf)
      M.format(Util.merge({}, filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = vim.lsp.get_clients(Util.merge({}, filter, { bufnr = buf }))
      ---@param client vim.lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client:supports_method("textDocument/formatting")
          or client:supports_method("textDocument/rangeFormatting")
      end, clients)
      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return Util.merge(ret, opts) --[[@as LazyFormatter]]
end

---@alias lsp.Client.format {timeout_ms?: number, format_options?: table} | vim.lsp.get_clients.Filter

---@param opts? lsp.Client.format
function M.format(opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {}, Util.opts("nvim-lspconfig").format or {})
  local ok, conform = pcall(require, "conform")
  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if ok then
    -- It should be `nil`, otherwise it doesn't fetch options from `formatters_by_ft`,
    -- see https://github.com/stevearc/conform.nvim/blob/5420c4b5ea0aeb99c09cfbd4fd0b70d257b44f25/lua/conform/init.lua#L417-L418
    opts.formatters = nil
    conform.format(opts)
  else
    vim.lsp.buf.format(opts)
  end
end

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler
---@field filter? string|vim.lsp.get_clients.Filter
---@field title? string

---@param opts LspCommand
function M.execute(opts)
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  local buf = vim.api.nvim_get_current_buf()

  ---@cast filter vim.lsp.get_clients.Filter
  local client = vim.lsp.get_clients(Util.merge({}, filter, { bufnr = buf }))[1]

  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  if opts.open then
    require("trouble").open({
      mode = "lsp_command",
      params = params,
    })
  else
    vim.list_extend(params, { title = opts.title })
    return client:exec_cmd(params, { bufnr = buf }, opts.handler)
  end
end

---@param filter? vim.lsp.get_clients.Filter
function M.code_actions(filter)
  filter = filter or {}
  local ret = {} ---@type string[]
  local clients = vim.lsp.get_clients(filter)
  for _, client in ipairs(clients) do
    -- check server cababilities first
    vim.list_extend(ret, vim.tbl_get(client, "server_capabilities", "codeActionProvider", "codeActionKinds") or {})
    -- check dynamic capabilities
    local regs = client.dynamic_capabilities:get("codeActionProvider", filter)
    for _, reg in ipairs(regs or {}) do
      vim.list_extend(ret, vim.tbl_get(reg, "registerOptions", "codeActionKinds") or {})
    end
  end
  return Util.dedup(ret)
end

-- Restart the clients attached to the current buffer -- the native equivalent of
-- lspconfig's :LspRestart, driven by `:help lsp.faq`: stop the clients, then reload
-- the buffer so they reattach. No vim.lsp.enable() needed, the config that enabled
-- them in the first place is still registered.
function M.restart()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })
  if #clients == 0 then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
    return
  end

  -- client:stop(), not vim.lsp.stop_client() -- the FAQ still shows the latter, but it's
  -- deprecated as of 0.12.
  for _, client in ipairs(clients) do
    client:stop()
  end

  -- Write first: `:edit` refuses a modified buffer, and forcing it would drop the
  -- changes. Only for real files -- :update throws on a nameless or special buffer.
  if vim.bo[buf].modified and vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
    vim.cmd("noautocmd update")
  end

  local names = vim.tbl_map(function(client)
    return client.name
  end, clients)

  -- The reload has to wait for the clients to actually exit, otherwise they're still
  -- in get_clients() when the fresh buffer asks for an attach and nothing restarts.
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd.edit()
      end)
    end
    vim.notify("Restarted: " .. table.concat(names, ", "), vim.log.levels.INFO, { title = "LSP" })
  end, 1000)
end

return M
