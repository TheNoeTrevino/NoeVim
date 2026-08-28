-- Custom Snacks picker sources. Split out of plugins/editor/picker.lua.
-- Layout tables live in util/picker/layouts.lua; this file holds behaviour only.

local layouts = require("util.picker.layouts")
local get_config = layouts.get_config

-- Drop locations already seen in this picker run. In an angular project both angularls and
-- vtsls answer definition/reference requests for a .ts buffer, and they answer identically, so
-- every hit is listed twice. Snacks can't collapse them: the `done` table in the lsp source's
-- get_locations is declared inside the per-client response handler, so it only ever dedups
-- within one client's results (and only when `unique_lines` is set, which also drops distinct
-- references sharing a line). ctx.meta is fresh per finder run, so nothing leaks between opens.
---@type snacks.picker.transform
local unique_location = function(item, ctx)
  local pos = item.pos or {}
  local key = table.concat({ item.file or item.text or "", pos[1] or 0, pos[2] or 0 }, ":")
  ctx.meta.locations = ctx.meta.locations or {}
  if ctx.meta.locations[key] then
    return false
  end
  ctx.meta.locations[key] = true
end

-- `gd` tries CSS class definitions before the LSP. Nothing in the LSP stack
-- resolves a class name in a template (see util/css.lua), and the util bails the
-- instant the cursor isn't on one, so this is a pure prefix on the normal jump.
---@param opts? snacks.picker.Config extra picker config, e.g. `{ confirm = "vsplit" }` for `gV`
local goto_definition = function(opts)
  opts = vim.tbl_deep_extend("force", get_config(), opts or {})
  local lsp = function()
    Snacks.picker.lsp_definitions(opts)
  end
  if not require("util").css.goto_definition(vim.tbl_extend("force", opts, { fallback = lsp })) then
    lsp()
  end
end

-- TODO: extract this lol
local grep_directory = function()
  local snacks = require("snacks")
  local has_fd = vim.fn.executable("fd") == 1
  local cwd = vim.fn.getcwd()

  local function show_picker(dirs)
    if #dirs == 0 then
      vim.notify("No directories found", vim.log.levels.WARN)
      return
    end

    local items = {}
    for i, item in ipairs(dirs) do
      table.insert(items, {
        idx = i,
        file = item,
        text = item,
      })
    end

    snacks.picker({
      confirm = function(picker, item)
        picker:close()
        snacks.picker.grep({
          dirs = { item.file },
        })
      end,
      items = items,
      format = function(item, _)
        local file = item.file
        local ret = {}
        local a = Snacks.picker.util.align
        local icon, icon_hl = Snacks.util.icon(file.ft, "directory")
        ret[#ret + 1] = { a(icon, 3), icon_hl }
        ret[#ret + 1] = { " " }
        local path = file:gsub("^" .. vim.pesc(cwd) .. "/", "")
        ret[#ret + 1] = { a(path, 20), "Directory" }

        return ret
      end,
      layout = {
        preview = false,
        reverse = false,
        layout = {
          backdrop = true,
          row = 1,
          width = 0.4,
          min_width = 80,
          height = 0.4,
          border = "none",
          box = "vertical",
          { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
          { win = "list", border = "single" },
          { win = "preview", title = "{preview}", border = "rounded" },
        },
      },
      title = "Grep in Directory",
    })
  end

  if has_fd then
    local cmd = { "fd", "--type", "directory", "--hidden", "--no-ignore-vcs", "--exclude", ".git" }
    local dirs = {}

    vim.fn.jobstart(cmd, {
      on_stdout = function(_, data, _)
        for _, line in ipairs(data) do
          if line and line ~= "" then
            table.insert(dirs, line)
          end
        end
      end,
      on_exit = function(_, code, _)
        if code == 0 then
          show_picker(dirs)
        else
          -- Fallback to plenary if fd fails
          local fallback_dirs = require("plenary.scandir").scan_dir(cwd, {
            only_dirs = true,
            respect_gitignore = true,
          })
          show_picker(fallback_dirs)
        end
      end,
    })
  else
    -- Use plenary if fd is not available
    local dirs = require("plenary.scandir").scan_dir(cwd, {
      only_dirs = true,
      respect_gitignore = true,
    })
    show_picker(dirs)
  end
end

local search_file_directory = function()
  local snacks = require("snacks")
  local has_fd = vim.fn.executable("fd") == 1
  local cwd = vim.fn.getcwd()

  local function show_picker(dirs)
    if #dirs == 0 then
      vim.notify("No directories found", vim.log.levels.WARN)
      return
    end

    local items = {}
    for i, item in ipairs(dirs) do
      table.insert(items, {
        idx = i,
        file = item,
        text = item,
      })
    end

    snacks.picker({
      confirm = function(picker, item)
        picker:close()
        snacks.picker.files({
          dirs = { item.file },
        })
      end,
      items = items,
      format = function(item, _)
        local file = item.file
        local ret = {}
        local a = Snacks.picker.util.align
        local icon, icon_hl = Snacks.util.icon(file.ft, "directory")
        ret[#ret + 1] = { a(icon, 3), icon_hl }
        ret[#ret + 1] = { " " }
        local path = file:gsub("^" .. vim.pesc(cwd) .. "/", "")
        ret[#ret + 1] = { a(path, 20), "Directory" }

        return ret
      end,
      layout = {
        preview = false,
        reverse = false,
        layout = {
          backdrop = true,
          row = 1,
          width = 0.4,
          min_width = 80,
          height = 0.4,
          border = "none",
          box = "vertical",
          { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
          { win = "list", border = "single" },
          { win = "preview", title = "{preview}", border = "rounded" },
        },
      },
      title = "Search Files in Directory",
    })
  end

  if has_fd then
    local cmd = { "fd", "--type", "directory", "--hidden", "--no-ignore-vcs", "--exclude", ".git" }
    local dirs = {}

    vim.fn.jobstart(cmd, {
      on_stdout = function(_, data, _)
        for _, line in ipairs(data) do
          if line and line ~= "" then
            table.insert(dirs, line)
          end
        end
      end,
      on_exit = function(_, code, _)
        if code == 0 then
          show_picker(dirs)
        else
          -- Fallback to plenary if fd fails
          local fallback_dirs = require("plenary.scandir").scan_dir(cwd, {
            only_dirs = true,
            respect_gitignore = true,
          })
          show_picker(fallback_dirs)
        end
      end,
    })
  else
    -- Use plenary if fd is not available
    local dirs = require("plenary.scandir").scan_dir(cwd, {
      only_dirs = true,
      respect_gitignore = true,
    })
    show_picker(dirs)
  end
end

-- Custom picker over the *tag stack* (`:tags` / <C-t>). Unlike Snacks.picker.tags
-- (which browses the ctags `tags` file), this shows the per-window history of tag
-- jumps you've actually taken. Each entry's `from` is where the cursor was when
-- you made that jump -- the same position <C-t> would pop you back to. Selecting
-- an entry jumps there and syncs the tag stack index so <C-t>/<C-]> stay coherent.
local tagstack_picker = function()
  local stack = vim.fn.gettagstack()
  local tags = stack.items or {}
  if #tags == 0 then
    vim.notify("Tag stack is empty", vim.log.levels.INFO)
    return
  end

  local items = {}
  -- reverse: most recent jump on top. `rank` counts up from 1 = most recent,
  -- so you can see how deep in the traversal each entry sits at a glance.
  local rank = 0
  for i = #tags, 1, -1 do
    rank = rank + 1
    local tag = tags[i]
    local from = tag.from -- { bufnr, lnum, col, off }
    local bufnr = from[1]
    local name = vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) or ""
    items[#items + 1] = {
      idx = i, -- 1-based index into the real tag stack
      rank = rank, -- 1 = most recent jump
      tag = tag.tagname,
      text = tag.tagname .. " " .. name, -- what the matcher searches on
      file = name,
      current = i == stack.curidx, -- where <C-t>/<C-]> currently point
      pos = { from[2], math.max((from[3] or 1) - 1, 0) }, -- {row (1-based), col (0-based)}
    }
  end

  Snacks.picker({
    items = items,
    format = function(item)
      local a = Snacks.picker.util.align
      local ret = {}
      ret[#ret + 1] = { item.current and "▶ " or "  ", "SnacksPickerSpecial" }
      ret[#ret + 1] = { a("#" .. item.rank, 4), "Number" } -- 1 = most recent
      ret[#ret + 1] = { " " }
      ret[#ret + 1] = { a(item.tag, 30), "Function" }
      ret[#ret + 1] = { " " }
      ret[#ret + 1] = { vim.fn.fnamemodify(item.file, ":~:."), "Directory" }
      ret[#ret + 1] = { ":" .. item.pos[1], "Number" }
      return ret
    end,
    confirm = function(picker, item)
      picker:close()
      if not item or item.file == "" then
        return
      end
      -- move the real tag-stack pointer to the chosen entry, then jump there
      vim.fn.settagstack(vim.fn.winnr(), { curidx = item.idx }, "r")
      vim.cmd("edit " .. vim.fn.fnameescape(item.file))
      pcall(vim.api.nvim_win_set_cursor, 0, item.pos)
    end,
    title = "Tag Stack",
  })
end

-- Type hierarchy ("who extends this" / "what does this extend"). Snacks ships call
-- hierarchy but has no typeHierarchy source at all, so the LSP round-trip is hand-rolled
-- here. Two bits come from the same private module snacks' own lsp sources use:
-- `add_loc` stashes the client's offset_encoding on the item so Snacks.picker.util can
-- fix the column later (computing pos by hand is wrong for any non-ASCII identifier),
-- and `get_clients` filters to clients that actually answer the method.
--
-- `depth` 1 gives a flat list of direct sub/supertypes (the call-hierarchy pickers'
-- behavior); anything higher walks the graph and renders it as a tree with the type
-- under the cursor as the root.
local MAX_HIERARCHY_NODES = 500

-- lsp_symbol drops the tree indent whenever `workspace` is set, and drops the filename
-- when it isn't (see snacks picker/format.lua). A hierarchy wants both, so this is that
-- formatter's body with the two branches merged.
---@param item snacks.picker.Item
---@param picker snacks.Picker
local hierarchy_format = function(item, picker)
  local ret = {} ---@type snacks.picker.Highlight[]
  vim.list_extend(ret, Snacks.picker.format.tree(item, picker))
  local kind = item.kind or "Unknown" ---@type string
  kind = picker.opts.icons.kinds[kind] and kind or "Unknown"
  ret[#ret + 1] = { picker.opts.icons.kinds[kind], "SnacksPickerIcon" .. kind }
  ret[#ret + 1] = { " " }
  Snacks.picker.highlight.format(item, vim.trim((item.name or ""):gsub("\r?\n", " ")), ret)
  local offset = Snacks.picker.highlight.offset(ret, { char_idx = true })
  ret[#ret + 1] = { Snacks.picker.util.align(" ", math.max(50 - offset, 1)) }
  vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
  return ret
end

---@param kind "subtypes"|"supertypes"
---@param depth integer 1 = direct sub/supertypes only, >1 = recursive tree
---@param picker_opts? table
local type_hierarchy = function(kind, depth, picker_opts)
  local LSP = require("snacks.picker.source.lsp")
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local tree = depth > 1

  local clients = LSP.get_clients(buf, "textDocument/prepareTypeHierarchy")
  if #clients == 0 then
    vim.notify("No LSP client supports type hierarchy", vim.log.levels.WARN)
    return
  end

  -- Keyed by location, so the same type answered by two clients collapses (in a .ts
  -- buffer both vtsls and angularls reply, identically -- same reason unique_location
  -- exists above), and so a diamond in the graph can't send the walk in circles.
  local seen = {} ---@type table<string, boolean>
  local function key(res)
    local range = res.selectionRange or res.range or {}
    local start = range.start or {}
    return table.concat({ res.uri or "", start.line or 0, start.character or 0 }, ":")
  end

  ---@type { res: table, client: vim.lsp.Client, children: table[] }[]
  local roots = {}
  local nodes, pending, children_found = 0, 0, 0

  local show, request

  ---@param node table
  ---@param level integer
  local function expand(node, level)
    if level >= depth or nodes >= MAX_HIERARCHY_NODES then
      return
    end
    request(node.client, "typeHierarchy/" .. kind, { item = node.res }, function(result)
      for _, res in ipairs(result) do
        if not seen[key(res)] and nodes < MAX_HIERARCHY_NODES then
          seen[key(res)] = true
          nodes = nodes + 1
          children_found = children_found + 1
          local child = { res = res, client = node.client, children = {} }
          node.children[#node.children + 1] = child
          expand(child, level + 1)
        end
      end
    end)
  end

  -- Every in-flight request holds a slot in `pending`; the walk is done when it drains.
  -- Children are queued from inside the parent's handler, before that handler releases
  -- its own slot, so the counter can't hit zero mid-walk.
  function request(client, method, params, handler)
    pending = pending + 1
    local function settle()
      pending = pending - 1
      if pending == 0 then
        vim.schedule(show)
      end
    end
    local ok = client:request(method, params, function(err, result)
      if not err then
        handler(result or {})
      end
      settle()
    end, buf)
    if not ok then
      settle()
    end
  end

  function show()
    local items = {} ---@type snacks.picker.finder.Item[]
    local root = { text = "", root = true } ---@type snacks.picker.finder.Item

    ---@param node table
    ---@param parent snacks.picker.finder.Item
    local function add(node, parent)
      local res = node.res
      local item = {
        name = res.name,
        kind = LSP.symbol_kind(res.kind),
        detail = res.detail,
        parent = parent,
        tree = tree,
        item = res,
      } ---@type snacks.picker.finder.Item
      LSP.add_loc(item, { uri = res.uri, range = res.selectionRange or res.range }, node.client)
      item.text = table.concat({ item.kind, res.name, item.file or "" }, " ")
      items[#items + 1] = item
      for i, child in ipairs(node.children) do
        child.last = i == #node.children
        add(child, item)
      end
      item.last = node.last
      return item
    end

    for _, node in ipairs(roots) do
      if tree then
        -- keep the type under the cursor as the tree's root for context
        node.last = true
        add(node, root)
      else
        for i, child in ipairs(node.children) do
          child.last = i == #node.children
          add(child, root)
        end
      end
    end

    if children_found == 0 then
      vim.notify("No " .. kind .. " found", vim.log.levels.INFO)
      return
    end

    Snacks.picker(vim.tbl_deep_extend("force", picker_opts or {}, {
      items = items,
      title = kind:sub(1, 1):upper() .. kind:sub(2),
      format = tree and hierarchy_format or "lsp_symbol",
      workspace = true, -- lsp_symbol only shows the filename column when this is set
      -- keep_parents keeps ancestors visible while filtering; sort=false keeps the
      -- walk order intact so the tree stays a tree. Same pair lsp_symbols uses.
      matcher = tree and { keep_parents = true, sort = false } or nil,
      auto_confirm = not tree,
      jump = { tagstack = true, reuse_win = true },
    }))
  end

  pending = 1 -- sentinel: hold the counter open while the prepare requests go out
  for _, client in ipairs(clients) do
    request(
      client,
      "textDocument/prepareTypeHierarchy",
      vim.lsp.util.make_position_params(win, client.offset_encoding),
      function(result)
        for _, res in ipairs(result) do
          if not seen[key(res)] then
            seen[key(res)] = true
            local node = { res = res, client = client, children = {} }
            roots[#roots + 1] = node
            expand(node, 0)
          end
        end
      end
    )
  end
  pending = pending - 1
  if pending == 0 then
    vim.schedule(show)
  end
end


return {
  unique_location = unique_location,
  goto_definition = goto_definition,
  grep_directory = grep_directory,
  search_file_directory = search_file_directory,
  tagstack_picker = tagstack_picker,
  type_hierarchy = type_hierarchy,
}
