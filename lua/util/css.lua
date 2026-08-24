-- CSS class navigation for markup buffers: go-to-definition, hover, and a mark on
-- class names nothing declares.
--
-- No language server answers these. `html` only sees stylesheets linked from the
-- current document, `cssmodules_language_server` only follows JS/TS imports, and
-- `tailwindcss` gives hover/completion but never a location. So `gd` on
-- `bg-white` inside an Angular template has nothing to resolve and falls through
-- to whatever the LSP happens to say about the surrounding attribute.
--
-- Everything here works the same way: confirm via treesitter that we're looking
-- at a class name, then consult ripgrep over the project's stylesheets.
--
-- LAYOUT
--   locating a class name  class_at_cursor() -- walks up the tree from the cursor
--   searching stylesheets  find()            -- on demand, one class, two passes
--   go to definition       goto_definition() -- wired to gd in plugins/picker.lua
--   hover                  hover()           -- wired to K by attach(), below
--   class index            build_index()     -- every class in the project, cached
--   highlighting           highlight()       -- reads the index, never greps
--   setup                  setup()           -- called from config/autocmds.lua
--
-- goto_definition/hover return false the moment the cursor is off a class name so
-- the caller can fall through to its normal binding. That contract is what keeps
-- this out of the way in every buffer that has nothing to do with CSS.
--
-- TWO SEARCH STRATEGIES
-- gd and K need one class and grep for it on demand. Highlighting needs every
-- class in the buffer, so a grep per class would be absurd -- it reads a cached
-- project-wide index instead, rebuilt only on stylesheet writes or :CssIndex.
--
-- The on-demand search runs in two passes, because of where framework classes
-- actually live: pass 1 respects .gitignore and finds your own SCSS; pass 2 only
-- runs if that came up empty and adds --no-ignore to reach node_modules.
-- Bootstrap matters here -- its utilities are generated from the `$utilities` map
-- by @each loops, so the literal string `.bg-white` exists *only* in compiled
-- output (node_modules/bootstrap/dist/css). Grepping the scss you @import will
-- never find it, which is what makes this whole thing feel impossible by hand.
--
-- KNOWN LIMITS
-- SCSS interpolation (`&-white` inside `.bg {}`) produces a name no grep can see.
-- Classes from a CDN stylesheet aren't in the repo, so they read as undeclared --
-- hence the dimmed mark rather than a warning squiggle. The index skips files
-- over 4MB and the on-demand search doesn't, so a class declared only in a huge
-- generated stylesheet marks as undeclared yet still jumps correctly.

---@class util.css
local M = {}

M.config = {
  highlight = {
    enabled = true,
    -- "undefined" marks classes NO stylesheet declares; "defined" marks the ones
    -- that resolve; false disables the marking but keeps gd/K.
    --
    -- "defined" was the obvious first choice and it is useless in practice: in a
    -- real project with Bootstrap loaded, essentially every class you type
    -- resolves, so the whole attribute lights up and the mark says nothing. The
    -- rare case is the one worth seeing -- a typo, or a class whose rule got
    -- deleted out from under the template.
    mode = "undefined",
    -- Dimmed rather than a warning squiggle. A class can legitimately come from a
    -- CDN stylesheet that isn't in the repo, so this should read as "nothing to
    -- jump to", not as an error.
    hl_group_undefined = "CssClassUndefined",
    hl_group_defined = "CssClassDefined",
    filetypes = {
      "html",
      "htmlangular",
      "htmldjango",
      "vue",
      "svelte",
      "typescriptreact",
      "javascriptreact",
      "eruby",
      "templ",
      "astro",
      "php",
    },
    debounce = 150,
  },
  -- Buffer-local, set only on the filetypes above, so it stays out of every other
  -- buffer's way -- and so it still works in a template with no LSP attached,
  -- which a keys entry in lsp-config.lua could not. Falls through to
  -- vim.lsp.buf.hover() off a class name, so it only ever adds behavior.
  -- Set to false to skip.
  hover_key = "K",
}

-- ripgrep type names; `css` already covers .scss.
local STYLE_TYPES = { "css", "less", "sass", "stylus" }

-- Attribute names whose value carries class names. Angular decorates these
-- (`[ngClass]`, `[class.active]`) and JSX renames them, so names are normalized
-- before lookup -- see normalize_attr.
local CLASS_ATTRS = {
  class = true,
  classname = true,
  ngclass = true,
}

-- CSS identifier characters. Deliberately excludes `:` so the cursor picks one
-- segment out of a Tailwind-style `md:hover:flex`.
local IDENT = "[%w_%-]"

local ns = vim.api.nvim_create_namespace("util_css_classes")

--------------------------------------------------------------------------------
-- locating a class name
--------------------------------------------------------------------------------

---Strip binding decoration and any modifier suffix: `[class.active]` -> `class`,
---`[ngClass]` -> `ngclass`, `class:foo` (Svelte) -> `class`.
---@param name string
---@return string
local function normalize_attr(name)
  name = name:lower():gsub("^[%[%(%*#]+", ""):gsub("[%]%)]+$", "")
  return name:match("^([^.:]+)") or name
end

---@param name string?
---@return boolean
local function is_class_attr(name)
  return name ~= nil and CLASS_ATTRS[normalize_attr(name)] == true
end

---The class-attribute name owning `node`, across the three grammar shapes we
---care about:
---  html/angular plain: attribute > attribute_name + quoted_attribute_value
---  angular binding:    attribute > property_binding > binding_name|class_binding
---  tsx/jsx:            jsx_attribute > property_identifier + string
---@param node TSNode the `attribute` or `jsx_attribute` node
---@param buf integer
---@return string?
local function attr_name(node, buf)
  for i = 0, node:named_child_count() - 1 do
    local child = node:named_child(i)
    local t = child:type()
    if t == "attribute_name" or t == "property_identifier" then
      return vim.treesitter.get_node_text(child, buf)
    elseif t == "property_binding" then
      for j = 0, child:named_child_count() - 1 do
        local gt = child:named_child(j):type()
        if gt == "binding_name" or gt == "class_binding" then
          return vim.treesitter.get_node_text(child:named_child(j), buf)
        end
      end
    end
  end
end

---The identifier the cursor sits on, expanded to its full extent.
---@param line string
---@param col integer 0-based
---@return string?
local function word_at(line, col)
  local i = col + 1
  if i > #line or not line:sub(i, i):match(IDENT) then
    -- Cursor parked on a boundary (closing quote, space): take the word behind it.
    i = i - 1
    if i < 1 or not line:sub(i, i):match(IDENT) then
      return nil
    end
  end
  local s, e = i, i
  while s > 1 and line:sub(s - 1, s - 1):match(IDENT) do
    s = s - 1
  end
  while e < #line and line:sub(e + 1, e + 1):match(IDENT) do
    e = e + 1
  end
  return line:sub(s, e)
end

---The CSS class under the cursor, or nil if the cursor isn't in a class attribute.
---@param buf? integer
---@return string?
function M.class_at_cursor(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  -- get_node reads cached trees and returns nil when nothing has parsed the
  -- buffer yet, which is exactly the state a freshly opened file is in. Parse the
  -- cursor line first; anything already parsed for highlighting is a no-op.
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if not ok or not parser then
    return nil
  end
  pcall(parser.parse, parser, { row, row + 1 })

  local node = vim.treesitter.get_node({ bufnr = buf, pos = { row, col } })
  if not node then
    return nil
  end

  while node do
    local t = node:type()
    if t == "class_name" then
      -- Angular `[class.active]` -- the class is its own node, take it directly.
      return vim.treesitter.get_node_text(node, buf)
    elseif t == "attribute" or t == "jsx_attribute" then
      if not is_class_attr(attr_name(node, buf)) then
        return nil
      end
      local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
      -- Inside `[ngClass]="{ hide: loading }"` this also picks up `loading`, a
      -- component property rather than a class. That's fine: the grep finds
      -- nothing and we fall back to the LSP, which resolves it correctly.
      return word_at(line, col)
    elseif t == "start_tag" or t == "self_closing_tag" or t == "element" or t == "document" then
      -- Walked out of the attribute list without finding an attribute.
      return nil
    end
    node = node:parent()
  end
end

--------------------------------------------------------------------------------
-- searching stylesheets
--------------------------------------------------------------------------------

---@param s string
---@return string
local function rg_escape(s)
  return (s:gsub("[%^%$%.%[%]%(%)%*%+%?%{%}%|\\]", "\\%0"))
end

---@param args string[]
local function with_style_types(args)
  for _, t in ipairs(STYLE_TYPES) do
    vim.list_extend(args, { "-t", t })
  end
  return args
end

---@param class string
---@param root string
---@param ignored boolean include gitignored files (node_modules)
---@return string[]
local function rg_args(class, root, ignored)
  -- Trailing guard instead of a lookahead: ripgrep's default engine is Rust
  -- regex, which has no lookaround. `([^\w-]|$)` keeps `.bg-white` from matching
  -- inside `.bg-white-alt` while still allowing the rule to end the line.
  local pattern = "\\." .. rg_escape(class) .. "([^\\w-]|$)"
  local args = with_style_types({
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--max-count=50",
    "-g",
    "!*.min.css", -- a hit here is one 200KB line, useless in a preview
    "-g",
    "!.git",
  })
  if ignored then
    table.insert(args, "--no-ignore")
  end
  vim.list_extend(args, { "--", pattern, root })
  return args
end

---@param out string
---@return snacks.picker.finder.Item[]
local function parse(out)
  local items = {}
  for line in vim.gsplit(out, "\n", { trimempty = true }) do
    -- Greedy path so Windows drive letters survive; line/col anchor the rest.
    local file, lnum, lcol, text = line:match("^(.*):(%d+):(%d+):(.*)$")
    if file then
      items[#items + 1] = {
        idx = #items + 1,
        file = file,
        pos = { tonumber(lnum), tonumber(lcol) - 1 },
        line = text,
        text = vim.trim(text),
      }
    end
  end
  return items
end

---Find every rule declaring `class`, cheap pass first. Calls `cb` with an empty
---list if nothing matches anywhere.
---@param class string
---@param cb fun(items: snacks.picker.finder.Item[])
local function find(class, cb)
  local root = require("util").root()
  local function run(ignored)
    vim.system({ "rg", unpack(rg_args(class, root, ignored)) }, { text = true }, function(res)
      vim.schedule(function()
        local items = parse(res.stdout or "")
        if #items == 0 and not ignored then
          return run(true)
        end
        cb(items)
      end)
    end)
  end
  run(false)
end

--------------------------------------------------------------------------------
-- go to definition
--------------------------------------------------------------------------------

-- Snacks confirm actions that open a new window, mapped to the `:` command that
-- makes one. The single-hit path below jumps by hand, so it can't reuse the
-- picker's confirm action and has to split itself.
local split_cmd = { split = "split", vsplit = "vsplit", edit_split = "split", edit_vsplit = "vsplit" }

---@param class string
---@param item snacks.picker.finder.Item
---@param cmd? string window command to run before the jump, e.g. "vsplit"
local function jump(class, item, cmd)
  local from = { vim.api.nvim_get_current_buf(), unpack(vim.api.nvim_win_get_cursor(0)) }
  from[3] = from[3] + 1 -- settagstack wants a 1-based column
  vim.fn.settagstack(vim.api.nvim_get_current_win(), { items = { { tagname = class, from = from } } }, "t")

  vim.cmd("normal! m'") -- jumplist, so <C-o> works too
  if cmd then
    vim.cmd(cmd)
  end
  local win = vim.api.nvim_get_current_win() -- after the split, so we land in the new window
  vim.cmd.edit(vim.fn.fnameescape(item.file))
  pcall(vim.api.nvim_win_set_cursor, win, item.pos)
  vim.cmd("normal! zz")
end

---Jump to the stylesheet rule for the class under the cursor.
---
---Returns false immediately when the cursor isn't on a class name, so callers can
---fall through to their normal `gd`. When it returns true it owns the jump, and
---runs `opts.fallback` itself if no stylesheet declares the class -- that path
---matters for `[ngClass]="{ hide: loading }"`, where `loading` looks class-shaped
---but is a component property only the LSP can resolve.
---`opts.confirm` picks the window the jump lands in, so `confirm = "vsplit"` opens
---a split for one hit and for a hit picked out of the picker.
---@param opts? snacks.picker.Config|{fallback?: fun()} picker config for multiple hits
---@return boolean handled
function M.goto_definition(opts)
  if vim.fn.executable("rg") == 0 then
    return false
  end
  local class = M.class_at_cursor()
  if not class then
    return false
  end

  opts = vim.deepcopy(opts or {})
  local fallback = opts.fallback or vim.lsp.buf.definition
  opts.fallback = nil
  local cmd = split_cmd[opts.confirm]

  find(class, function(items)
    if #items == 0 then
      return fallback()
    elseif #items == 1 then
      return jump(class, items[1], cmd)
    end
    Snacks.picker(vim.tbl_deep_extend("force", opts, {
      items = items,
      format = "file",
      title = "CSS: ." .. class,
      jump = { tagstack = true, reuse_win = true },
    }))
  end)

  return true
end

--------------------------------------------------------------------------------
-- hover
--------------------------------------------------------------------------------

---Read the full rule starting at `lnum`, including any sibling selectors stacked
---above it and the whole brace-balanced body below.
---@param file string
---@param lnum integer 1-based
---@return string[]
local function read_rule(file, lnum)
  local ok, lines = pcall(vim.fn.readfile, file)
  if not ok or type(lines) ~= "table" then
    return {}
  end

  -- Walk back over stacked selectors: `.a,` / `.b,` / `.c {`.
  local first = lnum
  while first > 1 and lines[first - 1] and lines[first - 1]:match(",%s*$") do
    first = first - 1
  end

  local out, depth, started = {}, 0, false
  for i = first, math.min(#lines, first + 60) do
    local line = lines[i]
    out[#out + 1] = line
    local _, opens = line:gsub("{", "")
    local _, closes = line:gsub("}", "")
    depth = depth + opens - closes
    if opens > 0 then
      started = true
    end
    if started and depth <= 0 then
      break
    end
  end
  return out
end

---Show the stylesheet rule for the class under the cursor in a float.
---Returns false when the cursor isn't on a class name, so callers can fall
---through to their normal `K`.
---@param opts? {fallback?: fun()}
---@return boolean handled
function M.hover(opts)
  if vim.fn.executable("rg") == 0 then
    return false
  end
  local class = M.class_at_cursor()
  if not class then
    return false
  end
  local fallback = (opts or {}).fallback or vim.lsp.buf.hover

  find(class, function(items)
    if #items == 0 then
      return fallback()
    end
    local lines, root = {}, require("util").root()
    -- Cap at three rules: enough to show a base rule plus an override or two
    -- without turning the float into a scrollback.
    for i = 1, math.min(#items, 3) do
      local item = items[i]
      if i > 1 then
        lines[#lines + 1] = ""
      end
      local rel = item.file:gsub("^" .. vim.pesc(root) .. "/", "")
      lines[#lines + 1] = ("/* %s:%d */"):format(rel, item.pos[1])
      vim.list_extend(lines, read_rule(item.file, item.pos[1]))
    end
    if #items > 3 then
      lines[#lines + 1] = ""
      lines[#lines + 1] = ("/* +%d more -- gd to list them */"):format(#items - 3)
    end
    vim.lsp.util.open_floating_preview(lines, "css", {
      border = "rounded",
      title = "." .. class,
      max_width = 90,
      max_height = 30,
      focus_id = "css-class-hover",
    })
  end)

  return true
end

--------------------------------------------------------------------------------
-- class index (for highlighting)
--------------------------------------------------------------------------------

-- Capture a class selector only when a real selector character follows, which
-- keeps `url(theme.css)` and decimals like `1.5rem` out of the index. `)` is
-- deliberately absent from the trailing set for exactly that reason.
local SELECTOR_RE = "(\\.-?[_a-zA-Z][_a-zA-Z0-9-]*)[\\s,{:.\\[>~+]"

---@type table<string, table<string, true>> root -> set of class names
M._index = {}
---@type table<string, true>
local building = {}
---@type table<integer, true>
local attached = {}

---Build (or rebuild) the set of class names declared anywhere in the project.
---One --no-ignore pass so the index agrees with what `gd` can reach.
---@param force? boolean
---@param cb? fun(count: integer)
function M.build_index(force, cb)
  local root = require("util").root()
  if building[root] then
    return
  end
  if M._index[root] and not force then
    return cb and cb(vim.tbl_count(M._index[root]))
  end
  if vim.fn.executable("rg") == 0 then
    return
  end
  building[root] = true

  local args = with_style_types({
    "--no-filename",
    "--no-line-number",
    "--no-heading",
    "--color=never",
    "--no-ignore",
    "--max-filesize=4M",
    "-o",
    "-r",
    "$1",
    "-g",
    "!*.min.css",
    "-g",
    "!.git",
  })
  vim.list_extend(args, { "--", SELECTOR_RE, root })

  vim.system({ "rg", unpack(args) }, { text = true }, function(res)
    vim.schedule(function()
      building[root] = nil
      local set = {}
      for line in vim.gsplit(res.stdout or "", "\n", { trimempty = true }) do
        set[line:sub(2)] = true -- drop the leading `.`
      end
      M._index[root] = set
      for buf in pairs(attached) do
        if vim.api.nvim_buf_is_valid(buf) then
          M.highlight(buf)
        end
      end
      if cb then
        cb(vim.tbl_count(set))
      end
    end)
  end)
end

--------------------------------------------------------------------------------
-- highlighting
--------------------------------------------------------------------------------

-- Captures every class-attribute value so we can underline the names that
-- resolve. Angular's `[class.active]` puts the name in its own node, hence the
-- second pattern.
local QUERIES = {
  html = [[(attribute (attribute_name) @name (quoted_attribute_value (attribute_value) @value))]],
  angular = [[
    (attribute (attribute_name) @name (quoted_attribute_value (attribute_value) @value))
    (class_binding (class_name) @class)
  ]],
  tsx = [[(jsx_attribute (property_identifier) @name (string (string_fragment) @value))]],
}
QUERIES.javascript = QUERIES.tsx
QUERIES.typescript = QUERIES.tsx
QUERIES.vue = QUERIES.html
QUERIES.svelte = QUERIES.html
QUERIES.php = QUERIES.html
QUERIES.embedded_template = QUERIES.html
QUERIES.templ = QUERIES.html
QUERIES.astro = QUERIES.html

---@type table<string, vim.treesitter.Query|false>
local query_cache = {}

---@param lang string
---@return vim.treesitter.Query|false
local function get_query(lang)
  if query_cache[lang] == nil then
    local src = QUERIES[lang]
    local ok, q = false, nil
    if src then
      ok, q = pcall(vim.treesitter.query.parse, lang, src)
    end
    query_cache[lang] = ok and q or false
  end
  return query_cache[lang]
end

---Call `fn` for each identifier in `node`, with its buffer position.
---@param buf integer
---@param node TSNode
---@param fn fun(word: string, row: integer, col: integer, col_end: integer)
local function each_token(buf, node, fn)
  local srow, scol = node:range()
  local text = vim.treesitter.get_node_text(node, buf)
  for i, line in ipairs(vim.split(text, "\n", { plain = true })) do
    local row = srow + i - 1
    local base = i == 1 and scol or 0
    local init = 1
    while true do
      local s, e = line:find(IDENT .. "+", init)
      if not s then
        break
      end
      fn(line:sub(s, e), row, base + s - 1, base + e)
      init = e + 1
    end
  end
end

---Mark the class names in `buf` per `config.highlight.mode`.
---@param buf integer
function M.highlight(buf)
  local conf = M.config.highlight
  if not conf.enabled or not conf.mode or not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local root_dir = require("util").root({ buf = buf })
  local index = M._index[root_dir]
  if not index then
    return M.build_index()
  end

  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if not ok or not parser then
    return
  end

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local want_defined = conf.mode == "defined"
  local hl = want_defined and conf.hl_group_defined or conf.hl_group_undefined

  local function mark(word, row, col, col_end)
    if (index[word] == true) == want_defined then
      pcall(vim.api.nvim_buf_set_extmark, buf, ns, row, col, {
        end_col = col_end,
        hl_group = hl,
        priority = 120,
      })
    end
  end

  pcall(parser.parse, parser, true)
  parser:for_each_tree(function(tree, ltree)
    local query = get_query(ltree:lang())
    if not query then
      return
    end
    local name_id, value_id, class_id
    for id, name in ipairs(query.captures) do
      if name == "name" then
        name_id = id
      elseif name == "value" then
        value_id = id
      elseif name == "class" then
        class_id = id
      end
    end
    for _, match in query:iter_matches(tree:root(), buf, 0, -1) do
      local direct = class_id and match[class_id] and match[class_id][1]
      if direct then
        each_token(buf, direct, mark)
      else
        local name_node = name_id and match[name_id] and match[name_id][1]
        local value_node = value_id and match[value_id] and match[value_id][1]
        if name_node and value_node then
          local raw = vim.treesitter.get_node_text(name_node, buf)
          -- A bracketed binding's value is a TypeScript expression, not a class
          -- list: `[ngClass]="{ hide: loading }"` would otherwise flag `loading`
          -- as a missing class. The plain html grammar parses these as ordinary
          -- attributes, so the check has to be on the name, not the node type.
          -- Angular's own grammar routes `[class.active]` to the @class capture
          -- above, which is the only part of a binding that is really a class.
          if not raw:match("^[%[%(]") and is_class_attr(raw) then
            each_token(buf, value_node, mark)
          end
        end
      end
    end
  end)
end

---@type table<integer, uv.uv_timer_t>
local timers = {}

---@param buf integer
local function schedule_highlight(buf)
  if timers[buf] then
    timers[buf]:stop()
  else
    timers[buf] = vim.uv.new_timer()
  end
  timers[buf]:start(M.config.highlight.debounce, 0, function()
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        M.highlight(buf)
      end
    end)
  end)
end

---@param buf integer
function M.attach(buf)
  if attached[buf] then
    return
  end
  attached[buf] = true
  local group = vim.api.nvim_create_augroup("util_css_buf_" .. buf, { clear = true })

  vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufWinEnter" }, {
    buffer = buf,
    group = group,
    callback = function()
      schedule_highlight(buf)
    end,
  })
  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = buf,
    group = group,
    once = true,
    callback = function()
      attached[buf] = nil
      if timers[buf] then
        timers[buf]:stop()
        timers[buf]:close()
        timers[buf] = nil
      end
    end,
  })
  if M.config.hover_key then
    local function set_hover_key()
      vim.keymap.set("n", M.config.hover_key, function()
        if not M.hover() then
          vim.lsp.buf.hover()
        end
      end, { buffer = buf, desc = "Hover (CSS class or LSP)" })
    end
    set_hover_key()
    -- lsp-config.lua binds K from LspAttach, which fires *after* the FileType
    -- event that got us here -- and again for every client, so in an Angular
    -- buffer (angularls, html, tailwindcss, copilot) it lands four times. Rather
    -- than try to win that ordering, just re-assert ours after each attach and on
    -- every buffer entry; by the time you are sitting in the buffer pressing K,
    -- BufEnter has run. vim.keymap.set is idempotent, so this is free.
    vim.api.nvim_create_autocmd({ "LspAttach", "BufEnter" }, {
      buffer = buf,
      group = group,
      callback = vim.schedule_wrap(set_hover_key),
    })
  end

  M.build_index()
  schedule_highlight(buf)
end

--------------------------------------------------------------------------------
-- setup
--------------------------------------------------------------------------------

---@param opts? table
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- `default = true` so a colorscheme or your own override wins.
  vim.api.nvim_set_hl(0, "CssClassUndefined", { link = "DiagnosticUnnecessary", default = true })
  vim.api.nvim_set_hl(0, "CssClassDefined", { underline = true, default = true })

  local group = vim.api.nvim_create_augroup("util_css", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = M.config.highlight.filetypes,
    callback = function(ev)
      M.attach(ev.buf)
    end,
  })

  -- setup() runs on VeryLazy, which is *after* FileType has already fired for the
  -- buffer nvim was started with -- so `nvim foo.component.html` would never
  -- attach and K would stay on the LSP's mapping. Adopt what is already loaded.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(M.config.highlight.filetypes, vim.bo[buf].filetype) then
      M.attach(buf)
    end
  end

  -- A stylesheet edit can add or remove a class, so the index goes stale.
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = { "*.css", "*.scss", "*.sass", "*.less", "*.styl" },
    callback = function()
      M.build_index(true)
    end,
  })

  vim.api.nvim_create_user_command("CssIndex", function()
    M.build_index(true, function(count)
      vim.notify(("Indexed %d CSS classes"):format(count), vim.log.levels.INFO, { title = "css" })
    end)
  end, { desc = "Rebuild the CSS class index" })
end

return M
