-- Repaint inlay hints when a second client answers.
--
-- In a .ts buffer of an Angular project two clients advertise inlayHintProvider:
-- vtsls, and angularls (@angular/language-server declares it in its initialize
-- result, and answers out of getAngularInlayHints). vim/lsp/inlay_hint.lua asks
-- both, and both answers carry the same buffer version because nothing was typed
-- in between.
--
-- angularls returns null in the same millisecond for a .ts file with no inline
-- template. vtsls takes a second or two to type-check the file and then returns
-- the real hints. The stock handler redraws after each answer, and its decoration
-- provider stamps bufstate.applied[lnum] = bufstate.version once it has drawn a
-- line. Nothing clears applied when a later answer arrives at the same version,
-- so the redraw that angularls's empty answer triggered marks every visible line
-- as done, and vtsls's hints are never drawn on those lines.
--
-- Measured on resource-form-tab.component.ts on 2026-08-28, cursor on line 150:
-- vim.lsp.inlay_hint.get() held 85 hints, and the inlayhint namespace held 0
-- extmarks. Scrolling to a line that was off screen during the race drew hints
-- there, so the hints themselves were fine and only the paint was suppressed.
-- Clearing applied by hand drew all 34 hints of the visible range at once.
--
-- applied is a local of vim/lsp/inlay_hint.lua, reachable only through the
-- upvalues of the module's own functions. If that lookup ever fails, this file
-- changes nothing.
--
-- Delete this file to remove all of it.

local inlay_hint = vim.lsp.inlay_hint

--- The module-local bufstates table, keyed by bufnr.
local function find_bufstates()
  for _, fn in ipairs({ inlay_hint.is_enabled, inlay_hint.get, inlay_hint.on_refresh }) do
    if type(fn) == "function" then
      for i = 1, 60 do
        local name, value = debug.getupvalue(fn, i)
        if not name then
          break
        end
        if name == "bufstates" and type(value) == "table" then
          return value
        end
      end
    end
  end
end

local bufstates = find_bufstates()
local orig = vim.lsp.handlers["textDocument/inlayHint"]

if bufstates and type(orig) == "function" then
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx)
    local ret = orig(err, result, ctx)

    local bufnr = ctx and ctx.bufnr
    if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
      -- rawget, so that a buffer without hints is not created by the lookup.
      local state = rawget(bufstates, bufnr)
      if state and type(state.applied) == "table" and next(state.applied) then
        state.applied = {}
        vim.api.nvim__redraw({ buf = bufnr, valid = true, flush = false })
      end
    end

    return ret
  end
end
