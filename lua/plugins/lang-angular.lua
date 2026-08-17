-- Setup: npm install @angular/language-service --no-save
-- (use --save-dev in projects that need a pinned version).
local Util = require("util")

-- angularls has never advertised documentHighlightProvider -- not in v22, and not as
-- far back as @angular/language-server v12 -- so snacks.words has no client to ask in
-- a template buffer, and `]]`/`[[` are gated off the same capability. referencesProvider
-- is there, and for a symbol in a template it returns the same set, so documentHighlight
-- can be answered out of references instead.

--- Whether a client other than angularls already answers `method` for this buffer. In .ts
--- vtsls answers both documentHighlight and rename -- and it is Angular-aware there, since
--- the block below loads @angular/language-server into it as a tsserver plugin -- so a
--- second answer is never an improvement, only a duplicate. Compared by name rather than
--- id so that two angularls clients (two Angular projects in one session) do not both
--- stand down and leave nobody answering.
local function answered_elsewhere(method, bufnr)
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if c.name ~= "angularls" and c:supports_method(method, bufnr) then
      return true
    end
  end
  return false
end

--- nvim passes bufnr as nil (meaning the current buffer), 0, a number, or the deprecated
--- `{ bufnr = n }` form, depending on the call site.
local function resolve_bufnr(bufnr)
  if type(bufnr) == "table" then
    bufnr = bufnr.bufnr
  end
  return (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
end

--- Location[] -> DocumentHighlight[], dropping everything that is not in `bufnr`.
local function to_highlights(locations, bufnr)
  local want = vim.uri_to_fname(vim.uri_from_bufnr(bufnr))
  local ret = {}
  for _, loc in ipairs(locations or {}) do
    if vim.uri_to_fname(loc.uri) == want then
      ret[#ret + 1] = { range = loc.range, kind = 1 } -- DocumentHighlightKind.Text
    end
  end
  return ret
end

-- Has to run from on_init, not from an LspAttach hook: the `]]`/`[[` maps are bound
-- through Snacks.keymap with an `lsp` filter, which resolves `has = "documentHighlight"`
-- once per (client, buffer) at attach and memoises the miss. on_init lands before the
-- client attaches to anything, so the capability is already in place by then.
local function shim_document_highlight(client)
  client.server_capabilities.documentHighlightProvider = true

  local request = client.request
  ---@diagnostic disable-next-line: duplicate-set-field
  client.request = function(self, method, params, handler, bufnr)
    if method ~= "textDocument/documentHighlight" then
      return request(self, method, params, handler, bufnr)
    end
    bufnr = resolve_bufnr(bufnr)
    -- Never let the real method reach angularls, it does not implement it.
    if answered_elsewhere("textDocument/documentHighlight", bufnr) then
      return false
    end
    local refs = vim.tbl_deep_extend("force", params, { context = { includeDeclaration = true } })
    return request(self, "textDocument/references", refs, function(err, result, ctx)
      if err or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      local highlights = to_highlights(result, bufnr)
      if handler then
        return handler(err, highlights, vim.tbl_extend("force", ctx, { method = "textDocument/documentHighlight" }))
      end
      vim.lsp.util.buf_highlight_references(bufnr, highlights, self.offset_encoding)
    end, bufnr)
  end
end

-- Replaces the inherited `renameProvider = false` hack. angularls does implement rename
-- (`renameProvider = { prepareProvider = true }`), and in a template it is the only client
-- that can, so switching the capability off cost renaming there entirely. What the hack was
-- really avoiding is two capable clients in .ts: vim.lsp.buf.rename walks all of them and
-- prompts once each, and inc-rename gathers its preview references from all of them. Answer
-- the capability per buffer instead, so angularls only stands down where vtsls covers it.
local RENAME_METHODS = {
  ["textDocument/rename"] = true,
  ["textDocument/prepareRename"] = true,
}

--- Both vim.lsp.get_clients({ method = ... }) and inc-rename's own client filter go through
--- Client:supports_method, so shadowing it is enough to keep angularls out of the running --
--- including for the `has = "rename"` keymap gate, which is why this also belongs in on_init.
local function defer_rename_when_covered(client)
  local supports_method = client.supports_method
  ---@diagnostic disable-next-line: duplicate-set-field
  client.supports_method = function(self, method, bufnr)
    if RENAME_METHODS[method] and answered_elsewhere(method, resolve_bufnr(bufnr)) then
      return false
    end
    return supports_method(self, method, bufnr)
  end
end

return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "angular", "scss" })
      end
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html" },
        callback = function()
          vim.treesitter.start(nil, "angular")
        end,
      })
    end,
  },

  -- LSP Servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        angularls = {
          on_init = function(client)
            shim_document_highlight(client)
            defer_rename_when_covered(client)
          end,
        },
      },
    },
  },

  -- Configure tsserver plugin
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- vtsls is defined in lang-typescript-vtsls.lua, which may merge after this
      -- fragment depending on load order; ensure the table exists before extending.
      opts.servers = opts.servers or {}
      opts.servers.vtsls = opts.servers.vtsls or {}
      Util.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@angular/language-server",
          location = Util.get_pkg_path("angular-language-server", "/node_modules/@angular/language-server"),
          enableForWorkspaceTypeScriptVersions = false,
        },
      })
    end,
  },

  -- formatting
  {
    "conform.nvim",
    opts = function(_, opts)
      -- prettier is always part of this config (formatting-prettier.lua).
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.htmlangular = { "prettier" }
    end,
  },
}
