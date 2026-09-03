-- Drop the padding space that sits against the colon of an inlay hint.
--
-- tsserver marks a hint with whitespaceBefore/whitespaceAfter, and vtsls copies both
-- straight into paddingLeft/paddingRight (@vtsls/language-service/dist/index.js:9338).
-- VS Code draws them as a few pixels of margin. Neovim draws them as a real space
-- character (vim/lsp/inlay_hint.lua:350), so the hint pushes the code one column
-- further than VS Code does, on a column where the file has no space at all.
--
-- Two kinds carry the padding, dumped from resource-form-tab.component.ts on
-- 2026-08-28. A type hint (kind 1) leads with a colon and pads on the left. A
-- parameter name hint (kind 2) trails a colon and pads on the right:
--
--   k1 padL=true  [: boolean]     -> `id : number`   becomes `id: number`
--   k2 padR=true  [callbackfn:]   -> `map(callbackfn: (f)` becomes `map(callbackfn:(f)`
--
-- The colon is already in the label, so the padding only adds width. Only a label
-- that starts or ends with a colon loses it. An enum member value hint carries the
-- label `= 0` with the same paddingLeft, and there the space is wanted.
--
-- Delete this file to remove all of it, or delete one of the two `if` bodies below
-- to keep that side's spacing. See also lsp-inlay-hint-repaint.lua.

local orig = vim.lsp.handlers["textDocument/inlayHint"]

--- The rendered text of an InlayHint label, which is a string or a part list.
local function label_text(label)
  if type(label) == "string" then
    return label
  end
  if type(label) ~= "table" then
    return ""
  end
  local parts = {}
  for _, part in ipairs(label) do
    parts[#parts + 1] = type(part) == "table" and part.value or ""
  end
  return table.concat(parts)
end

if type(orig) == "function" then
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx)
    if type(result) == "table" then
      for _, hint in ipairs(result) do
        local text = label_text(hint.label)
        if hint.paddingLeft and text:sub(1, 1) == ":" then
          hint.paddingLeft = false
        end
        if hint.paddingRight and text:sub(-1) == ":" then
          hint.paddingRight = false
        end
      end
    end
    return orig(err, result, ctx)
  end
end
