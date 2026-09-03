-- Make jdtls's codeAction/resolve idempotent.
--
-- Proven from the RPC in ~/.local/state/nvim/lsp.log on 2026-08-20: resolving the
-- same jdtls code action twice returns two different ranges. For the "Import
-- 'SubmitterChange'" action on ProjectService.java, both requests carried the same
-- payload, data = { pid = "0", rid = "2" }. The first answer ended the replaced
-- range at (line 37, char 68), the end of the last import line. The second ended it
-- at (line 39, char 26), the middle of a word. The newText was byte-identical both
-- times. Applying the second answer corrupts the file.
--
-- tiny-code-action resolves twice on the snacks picker path. base/previewer.lua
-- resolves once to draw the diff and caches the result on the entry as
-- _resolved_action. pickers/snacks.lua then calls apply_action without that cache,
-- so base/picker.lua resolves the same action again and applies the second answer.
-- The telescope and buffer pickers pass the cache on, so they never hit this.
--
-- Patching the plugin file works, but a lazy update reverts it. This fixes the
-- server behaviour instead, so it holds for any picker and for vim.lsp.buf.code_action.
--
-- The request still reaches the server. Only the answer is replaced, so no request
-- id and no cancellation plumbing changes. The cache is keyed on the buffer version,
-- so it drops itself as soon as the buffer moves.
--
-- Delete this file to remove all of it. See also jdtls-edit-guard.lua, which logs
-- every applied edit to ~/jdtls-edits.log.

---@type table<integer, { version: integer, entries: table<string, table> }>
local cache = {}

local function action_key(params)
  if type(params) ~= "table" then
    return nil
  end
  return vim.inspect({ data = params.data, title = params.title, kind = params.kind })
end

local function bucket(bufnr)
  local version = vim.lsp.util.buf_versions[bufnr]
  local b = cache[bufnr]
  if not b or b.version ~= version then
    b = { version = version, entries = {} }
    cache[bufnr] = b
  end
  return b
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "jdtls" then
      return
    end
    if rawget(client, "_jdtls_resolve_cache") then
      return
    end
    client._jdtls_resolve_cache = true

    local orig = client.request

    client.request = function(self, method, params, handler, bufnr)
      -- Anything but the 0.11+ client:request(...) form goes through untouched.
      if type(self) ~= "table" or method ~= "codeAction/resolve" then
        return orig(self, method, params, handler, bufnr)
      end
      if type(handler) ~= "function" then
        return orig(self, method, params, handler, bufnr)
      end

      local key = action_key(params)
      if not key then
        return orig(self, method, params, handler, bufnr)
      end

      local buf = bufnr or vim.api.nvim_get_current_buf()

      local wrapped = function(err, result, ctx, config)
        if not err and type(result) == "table" then
          local b = bucket(buf)
          if b.entries[key] then
            result = b.entries[key]
          else
            b.entries[key] = result
          end
        end
        return handler(err, result, ctx, config)
      end

      return orig(self, method, params, wrapped, bufnr)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(args)
    cache[args.buf] = nil
  end,
})
