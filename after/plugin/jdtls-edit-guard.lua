-- Guard + tracer for jdtls code-action edits landing at the wrong offsets.
--
-- Symptom this exists for: accepting an "add import" quickfix replaced the first
-- 19 characters of an unrelated import line instead of inserting a new one, i.e.
-- jdtls handed over a range computed against a document that was not the buffer.
--
-- Two reasons nothing catches that today:
--   * Neovim already has the right check -- ctx_is_valid() in
--     runtime/lua/vim/lsp/buf.lua compares vim.lsp.util.buf_versions[bufnr]
--     against ctx.version -- but the code-action apply path (on_user_choice ->
--     apply_action -> util.apply_workspace_edit) never calls it.
--   * apply_text_document_edit does have a staleness check, but it is skipped
--     entirely when textDocument.version is null, and jdtls sends null.
--
-- So: stamp the buffer version when a code-action list is requested, and refuse
-- the resulting edit if the buffer moved before it was applied. Everything is
-- logged either way, so a bad edit leaves its ranges behind instead of vanishing
-- into a single undo.
--
-- Delete this file to remove all of it.

local REFUSE = true -- set false to warn but still apply
local LOG = vim.fn.expand("~/jdtls-edits.log")
local STAMP_TTL_MS = 60000

---@type table<integer, { version: integer, at: integer }>
local stamps = {}

local function write(tag, data)
  local fh = io.open(LOG, "a")
  if not fh then
    return
  end
  fh:write(("\n==== %s | %s ====\n%s\n"):format(os.date("%F %T"), tag, vim.inspect(data)))
  fh:close()
end

-- Record the buffer version at the moment the code-action list is requested.
-- That is the version jdtls computes its cached proposals against; the edit only
-- materialises later, on codeAction/resolve.
vim.api.nvim_create_autocmd("LspRequest", {
  callback = function(args)
    local req = args.data.request
    if not req or req.type ~= "pending" or req.method ~= "textDocument/codeAction" then
      return
    end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "jdtls" then
      return
    end
    stamps[req.bufnr] = { version = vim.lsp.util.buf_versions[req.bufnr], at = vim.uv.now() }
  end,
})

-- bufnr -> version the server claimed for it (false when it claimed none)
local function targets(edit)
  local out = {}
  for _, change in ipairs(edit.documentChanges or {}) do
    if change.textDocument then
      out[vim.uri_to_bufnr(change.textDocument.uri)] = change.textDocument.version
    end
  end
  for uri in pairs(edit.changes or {}) do
    local bufnr = vim.uri_to_bufnr(uri)
    if out[bufnr] == nil then
      out[bufnr] = false
    end
  end
  return out
end

-- The line each edit is about to land on, so a wrong range is legible after the fact.
local function landing_lines(edit)
  local out = {}
  local function collect(uri, edits)
    local bufnr = vim.uri_to_bufnr(uri)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      return
    end
    for _, e in ipairs(edits or {}) do
      local l = e.range.start.line
      out[("%d:%d"):format(bufnr, l)] = vim.api.nvim_buf_get_lines(bufnr, l, l + 1, false)[1]
    end
  end
  for _, change in ipairs(edit.documentChanges or {}) do
    if change.textDocument then
      collect(change.textDocument.uri, change.edits)
    end
  end
  for uri, edits in pairs(edit.changes or {}) do
    collect(uri, edits)
  end
  return out
end

local orig = vim.lsp.util.apply_workspace_edit

vim.lsp.util.apply_workspace_edit = function(edit, encoding)
  local seen = targets(edit)
  local stale

  for bufnr, server_version in pairs(seen) do
    local stamp = stamps[bufnr]
    stamps[bufnr] = nil -- a stamp guards exactly one apply
    if stamp and (vim.uv.now() - stamp.at) < STAMP_TTL_MS then
      local now = vim.lsp.util.buf_versions[bufnr]
      if now ~= stamp.version then
        stale = {
          bufnr = bufnr,
          version_at_request = stamp.version,
          version_now = now,
          version_from_server = server_version,
        }
      end
    end
  end

  write(stale and "STALE EDIT REFUSED" or "apply_workspace_edit", {
    stale = stale,
    targets = seen,
    lines_before = landing_lines(edit),
    edit = edit,
  })

  if stale then
    vim.notify(
      ("Refused a stale code-action edit: buffer moved %s -> %s since the action was requested. Re-trigger it.")
        :format(tostring(stale.version_at_request), tostring(stale.version_now)),
      vim.log.levels.WARN
    )
    if REFUSE then
      return
    end
  end

  return orig(edit, encoding)
end
