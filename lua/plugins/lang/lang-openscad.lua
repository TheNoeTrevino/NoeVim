-- OpenSCAD tooling: a hand-registered treesitter parser, the openscad-lsp server
-- with a treesitter-backed documentHighlight shim, and the openscad.nvim plugin.
--
-- Filetype detection is free: Neovim maps *.scad to the `openscad` filetype in
-- runtime/lua/vim/filetype.lua and ships runtime/syntax/openscad.vim as a fallback.
-- Highlighting has three layers here, and the last one to attach wins:
-- the Neovim syntax file, then openscad.nvim's richer syntax/openscad.vim, then
-- treesitter. vim/treesitter/highlighter.lua sets `vim.bo.syntax = ''` when it
-- attaches, so once the parser is installed the syntax files stop mattering.

--- nvim passes bufnr as nil (meaning the current buffer), 0, a number, or the
--- deprecated `{ bufnr = n }` form, depending on the call site.
local function resolve_bufnr(bufnr)
  if type(bufnr) == "table" then
    bufnr = bufnr.bufnr
  end
  return (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
end

local function line_at(bufnr, row)
  return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
end

-- LSP positions count utf-16 units (openscad-lsp negotiates utf-16), treesitter
-- counts bytes. Convert at both boundaries so a non-ASCII comment earlier on the
-- line cannot shift a highlight sideways.
local function to_byte_col(bufnr, row, col, encoding)
  if encoding == "utf-8" then
    return col
  end
  local line = line_at(bufnr, row)
  if not line then
    return col
  end
  local ok, byte = pcall(vim.str_byteindex, line, encoding, col, false)
  return ok and byte or col
end

local function to_lsp_col(bufnr, row, col, encoding)
  if encoding == "utf-8" then
    return col
  end
  local line = line_at(bufnr, row)
  if not line then
    return col
  end
  local ok, idx = pcall(vim.str_utfindex, line, encoding, col, false)
  return ok and idx or col
end

--- DocumentHighlight[] for the identifier at `position`, resolved out of the
--- grammar's locals.scm instead of out of the server.
---
--- Matched buffer-wide by name, not scope-aware. locals.scm does declare scopes
--- (module_item, transform_chain, union_block, if_block, for_block), but a .scad
--- file is mostly top-level constants read from inside every module, which is
--- precisely what a scope walk would narrow away.
local function locals_highlights(bufnr, position, encoding)
  local query = vim.treesitter.query.get("openscad", "locals")
  if not query then
    return {}
  end
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "openscad")
  if not ok or not parser then
    return {}
  end
  local tree = parser:parse()[1]
  if not tree then
    return {}
  end
  local root = tree:root()

  local row = position.line
  local col = to_byte_col(bufnr, row, position.character, encoding)
  local node = root:named_descendant_for_range(row, col, row, col)
  if not node or node:type() ~= "identifier" then
    return {}
  end
  local want = vim.treesitter.get_node_text(node, bufnr)
  if want == "" then
    return {}
  end

  -- `(identifier) @local.reference` in locals.scm matches EVERY identifier,
  -- including the ones a definition capture already claimed, so the same node
  -- arrives twice. Key by range and let the definition kind win, otherwise every
  -- definition gets two stacked extmarks.
  local by_range = {} ---@type table<string, table>
  local order = {} ---@type string[]
  for id, n in query:iter_captures(root, bufnr, 0, -1) do
    local capture = query.captures[id]
    -- DocumentHighlightKind: 2 = Read, 3 = Write. kanagawa paints
    -- LspReferenceRead, LspReferenceWrite and LspReferenceText identically here
    -- (ui.lua only overrides Text), so the split costs nothing today and is
    -- already right if those groups ever diverge.
    local kind = (capture == "local.reference" and 2) or (capture:find("^local%.definition") and 3) or nil
    if kind and vim.treesitter.get_node_text(n, bufnr) == want then
      local sr, sc, er, ec = n:range()
      local key = table.concat({ sr, sc, er, ec }, ":")
      if not by_range[key] then
        order[#order + 1] = key
        by_range[key] = {
          range = {
            start = { line = sr, character = to_lsp_col(bufnr, sr, sc, encoding) },
            ["end"] = { line = er, character = to_lsp_col(bufnr, er, ec, encoding) },
          },
          kind = kind,
        }
      elseif kind > by_range[key].kind then
        by_range[key].kind = kind
      end
    end
  end

  local ret = {}
  for _, key in ipairs(order) do
    ret[#ret + 1] = by_range[key]
  end
  return ret
end

--- openscad-lsp advertises hover, definition, documentSymbol, rename, completion
--- and formatting, and nothing else -- no documentHighlightProvider, so
--- Snacks.words has no client to ask, and `]]`/`[[` are gated off the same
--- capability.
---
--- lang-angular.lua closes the identical gap by rewriting documentHighlight into a
--- references request. That does NOT port here: openscad-lsp has no
--- referencesProvider either, so there is nothing to rewrite into. The grammar's
--- locals.scm answers it instead, which is why the treesitter parser above is a
--- prerequisite and not a nicety.
---
--- Has to run from on_init, not from an LspAttach hook: the `]]`/`[[` maps are
--- bound through Snacks.keymap with an `lsp` filter, which resolves
--- `has = "documentHighlight"` once per (client, buffer) at attach and memoises
--- the miss. on_init lands before the client attaches to anything.
local function shim_document_highlight(client)
  client.server_capabilities.documentHighlightProvider = true

  local request = client.request
  ---@diagnostic disable-next-line: duplicate-set-field
  client.request = function(self, method, params, handler, bufnr)
    if method ~= "textDocument/documentHighlight" then
      return request(self, method, params, handler, bufnr)
    end
    bufnr = resolve_bufnr(bufnr)
    -- The real method never goes out; the server does not implement it.
    --
    -- The reply MUST be deferred, even though nothing here is async. Snacks
    -- words.lua:81 runs
    --     vim.lsp.buf.document_highlight()   then   vim.lsp.buf.clear_references()
    -- back to back, and that only works because a real request is asynchronous:
    -- clear() wipes the previous marks and the response paints the new ones after
    -- it. Answering inline would paint first and let clear() erase the lot, so the
    -- highlight would never once appear on screen.
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      local highlights = locals_highlights(bufnr, params.position, self.offset_encoding)
      if handler then
        return handler(nil, highlights, { method = method, client_id = self.id, bufnr = bufnr })
      end
      vim.lsp.util.buf_highlight_references(bufnr, highlights, self.offset_encoding)
    end)
    return true
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- nvim-treesitter has no `openscad` entry of its own (grep its parsers.lua --
    -- zero hits), so register the grammar by hand.
    --
    -- It MUST be an autocmd, and `init` is what guarantees the autocmd exists
    -- before the plugin loads. Registering from an `opts` function looks right and
    -- silently does nothing: install.lua's reload_parsers() runs
    --   package.loaded["nvim-treesitter.parsers"] = nil
    -- at the top of every M.install/M.update, throwing away the table you mutated,
    -- and only THEN fires `User TSUpdate`. Re-registering from that event is the
    -- one hook that survives the reload. Measured: with the opts-function version
    -- the install logged "skipping unsupported language: openscad".
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        group = vim.api.nvim_create_augroup("openscad_treesitter", { clear = true }),
        callback = function()
          require("nvim-treesitter.parsers").openscad = {
            install_info = {
              -- The openscad org's fork, not bollian's original. The org repo is
              -- the one still moving (Aug 2026 vs Aug 2024) and it carries
              -- src/parser.c pre-generated, so installing needs a C compiler but
              -- not the tree-sitter CLI.
              url = "https://github.com/openscad/tree-sitter-openscad",
              revision = "27329e1905a346131d6beb6e2a32fed8cd7e2816",
              -- The field that makes highlighting happen at all. Without it the
              -- install builds the parser and then looks for queries under
              -- nvim-treesitter's OWN runtime/queries/openscad/, which does not
              -- exist -- so TSUtil.have(ft, "highlights") stays false, the
              -- FileType hook in treesitter.lua never calls vim.treesitter.start,
              -- and you get a working parser with zero colour. With it, install
              -- copies the grammar's queries/ out of the tarball: highlights,
              -- indents, injections, locals. Those already use Neovim capture
              -- names (@function.call, @keyword.conditional, @variable.parameter),
              -- so nothing needs porting. locals is what feeds the
              -- documentHighlight shim above.
              queries = "queries",
            },
            -- 1=stable 2=unstable 3=unmaintained 4=unsupported. Only 4 changes
            -- behaviour (config.lua drops it from the available list); 2 is the
            -- honest label for a third-party grammar we pin ourselves.
            tier = 2,
          }
        end,
      })
    end,
    -- Plain table, not a function: opts_extend = { "ensure_installed" } in
    -- treesitter.lua concatenates this in, same as lang-make.lua does for "make".
    -- No vim.treesitter.language.register call is needed because the parser name
    -- and the filetype are both "openscad".
    opts = { ensure_installed = { "openscad" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Leathong/openscad-LSP, Rust, Apache-2.0. Mason has it as `openscad-lsp`
        -- 2.0.2 and its registry entry carries neovim.lspconfig = "openscad_lsp",
        -- so this bare entry is enough: lsp-config.lua's `configure()` finds it in
        -- mason-lspconfig's lspconfig_to_package map and installs it via cargo.
        --
        -- NOT `openscad_ls`, the other server nvim-lspconfig ships a config for.
        -- That one is dzhu/openscad-language-server: still 0.1.0, orphaned in the
        -- AUR since July 2022, and absent from mason-lspconfig's map (its registry
        -- entry has no `neovim` key), so it could not auto-install even if wanted.
        openscad_lsp = {
          on_init = function(client)
            shim_document_highlight(client)
          end,
        },
      },
    },
  },
  {
    -- Syntax file, cheatsheet float, ~60 LuaSnip snippets, the offline OpenSCAD
    -- manual, a fuzzy picker over an 85-file help tree, and "open this file in the
    -- OpenSCAD GUI". Alive: refactored for nvim 0.10+ in April 2026. No language
    -- server of its own, so it sits alongside openscad_lsp rather than replacing it.
    --
    -- Weighs 15 MB on disk: 7.7 MB of help_source (a 4.9 MB language reference PDF
    -- and a 2.6 MB manual) and 6.5 MB of .git. GitHub reports the repo as 46 MB,
    -- but lazy clones --filter=blob:none, so the old PDF revisions never land.
    "salkin-mada/openscad.nvim",
    -- Safe despite the plugin registering its own `FileType openscad` autocmd at
    -- require() time: lazy re-emits the event after loading an ft-lazy spec, so
    -- the autocmd still fires for the buffer that triggered the load.
    ft = "openscad",
    -- snacks is NOT listed: M.help() resolves the picker with pcall(require) only
    -- when you actually press the key, and snacks is loaded by then anyway.
    -- LuaSnip is, because load_snippets() runs on the first .scad buffer.
    dependencies = { "L3MON4D3/LuaSnip" },
    config = function()
      -- Read by M.setup() on the first .scad buffer, so plain globals, no setup().
      vim.g.openscad_load_snippets = true
      -- blink.cmp runs snippets = { preset = "luasnip" }, so these show up in the
      -- normal completion menu rather than needing a separate source.

      -- Left at the plugin default (false) on purpose. It only fills in the four
      -- *_trig_key globals below with ITS defaults, and one of those is <Enter> in
      -- normal mode -- which would cost the plain "down a line" motion in every
      -- .scad buffer. The other three are <A-h>/<A-m>/<A-o>, and Hyprland eats
      -- ALT chords before Neovim sees them. Set the keys directly instead.
      vim.g.openscad_default_mappings = false

      -- M.set_mappings() always runs and skips nil keys, so naming them here is the
      -- whole mapping story. Buffer-local, normal mode, .scad only.
      -- <localleader> is "," here; <leader>o is already the Overseer group.
      vim.g.openscad_cheatsheet_toggle_key = "<localleader>oc"
      vim.g.openscad_help_trig_key = "<localleader>oh"
      vim.g.openscad_manual_trig_key = "<localleader>om"
      vim.g.openscad_exec_openscad_trig_key = "<localleader>oo"

      -- M.manual() warns and bails when this is empty, which is the default. It
      -- spawns { cmd, pdf } detached -- zathura is installed at /usr/bin/zathura.
      vim.g.openscad_pdf_cmd = "zathura"

      -- Off: true would launch the OpenSCAD GUI on the first .scad buffer of the
      -- session, whether or not you wanted to look at the render.
      vim.g.openscad_auto_open = false

      -- No setup() call -- requiring the module is what registers the filetype
      -- mapping for .scadhelp and the FileType autocmd that does the real work.
      require("openscad")
    end,
  },
}
