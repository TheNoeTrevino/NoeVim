-- THE home of the entire format subsystem (self-contained):
--   * the engine below: register/resolve/format/...
--   * the conform.nvim spec below
--   * M.setup(): autoformat autocmd + <leader>cf/cF/uf/uF commands, wired on VeryLazy
--   * formatexpr and the LSP formatter registration (lsp-config.lua registers into THIS engine)
--
-- The engine is exposed as the `util.format` module via package.loaded (set at spec
-- collection time, before anything reads it), so `Util.format.*` (the util metatable
-- proxy) and `v:lua.require'util.format'.formatexpr()` resolve to this one table.

local Util = require("util")

-- ===========================================================================
-- Format engine
-- ===========================================================================
---@class util.format
---@overload fun(opts?: {force?:boolean})
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.format(...)
  end,
})

-- Expose as the `util.format` module so Util.format.* and v:lua.require'util.format'
-- resolve here. Set at require-time (spec collection), before any consumer reads it.
package.loaded["util.format"] = M

---@class LazyFormatter
---@field name string
---@field primary? boolean
---@field format fun(bufnr:number)
---@field sources fun(bufnr:number):string[]
---@field priority number

M.formatters = {} ---@type LazyFormatter[]

---@param formatter LazyFormatter
function M.register(formatter)
  M.formatters[#M.formatters + 1] = formatter
  table.sort(M.formatters, function(a, b)
    return a.priority > b.priority
  end)
end

function M.formatexpr()
  if Util.has("conform.nvim") then
    return require("conform").formatexpr()
  end
  return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

---@param buf? number
---@return (LazyFormatter|{active:boolean,resolved:string[]})[]
function M.resolve(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local have_primary = false
  ---@param formatter LazyFormatter
  return vim.tbl_map(function(formatter)
    local sources = formatter.sources(buf)
    local active = #sources > 0 and (not formatter.primary or not have_primary)
    have_primary = have_primary or (active and formatter.primary) or false
    return setmetatable({
      active = active,
      resolved = sources,
    }, { __index = formatter })
  end, M.formatters)
end

---@param buf? number
function M.info(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local gaf = vim.g.autoformat == nil or vim.g.autoformat
  local baf = vim.b[buf].autoformat
  local enabled = M.enabled(buf)
  local lines = {
    "# Status",
    ("- [%s] global **%s**"):format(gaf and "x" or " ", gaf and "enabled" or "disabled"),
    ("- [%s] buffer **%s**"):format(
      enabled and "x" or " ",
      baf == nil and "inherit" or baf and "enabled" or "disabled"
    ),
  }
  local have = false
  for _, formatter in ipairs(M.resolve(buf)) do
    if #formatter.resolved > 0 then
      have = true
      lines[#lines + 1] = "\n# " .. formatter.name .. (formatter.active and " ***(active)***" or "")
      for _, line in ipairs(formatter.resolved) do
        lines[#lines + 1] = ("- [%s] **%s**"):format(formatter.active and "x" or " ", line)
      end
    end
  end
  if not have then
    lines[#lines + 1] = "\n***No formatters available for this buffer.***"
  end
  Util[enabled and "info" or "warn"](
    table.concat(lines, "\n"),
    { title = "LazyFormat (" .. (enabled and "enabled" or "disabled") .. ")" }
  )
end

---@param buf? number
function M.enabled(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local gaf = vim.g.autoformat
  local baf = vim.b[buf].autoformat

  -- If the buffer has a local value, use that
  if baf ~= nil then
    return baf
  end

  -- Otherwise use the global value if set, or true by default
  return gaf == nil or gaf
end

---@param buf? boolean
function M.toggle(buf)
  M.enable(not M.enabled(), buf)
end

---@param enable? boolean
---@param buf? boolean
function M.enable(enable, buf)
  if enable == nil then
    enable = true
  end
  if buf then
    vim.b.autoformat = enable
  else
    vim.g.autoformat = enable
    vim.b.autoformat = nil
  end
  M.info()
end

---@param opts? {force?:boolean, buf?:number}
function M.format(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  if not ((opts and opts.force) or M.enabled(buf)) then
    return
  end

  local done = false
  for _, formatter in ipairs(M.resolve(buf)) do
    if formatter.active then
      done = true
      Util.try(function()
        return formatter.format(buf)
      end, { msg = "Formatter `" .. formatter.name .. "` failed" })
    end
  end

  if not done and opts and opts.force then
    Util.warn("No formatter available", { title = "Format" })
  end
end

function M.setup()
  -- Autoformat autocmd. Own augroup ("format").
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("format", { clear = true }),
    callback = function(event)
      M.format({ buf = event.buf })
    end,
  })

  -- Manual format
  vim.api.nvim_create_user_command("LazyFormat", function()
    M.format({ force = true })
  end, { desc = "Format selection or buffer" })

  -- Format info
  vim.api.nvim_create_user_command("LazyFormatInfo", function()
    M.info()
  end, { desc = "Show info about the formatters for the current buffer" })
end

---@param buf? boolean
function M.snacks_toggle(buf)
  return Snacks.toggle({
    name = "Auto Format (" .. (buf and "Buffer" or "Global") .. ")",
    get = function()
      if not buf then
        return vim.g.autoformat == nil or vim.g.autoformat
      end
      return M.enabled()
    end,
    set = function(state)
      M.enable(state, buf)
    end,
  })
end

-- ===========================================================================
-- conform.nvim plugin spec (base opts merged with the personal
-- formatters/formatters_by_ft, the personal ones winning)
-- ===========================================================================
return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  event = "BufWritePre",
  keys = {
    {
      "<leader>cf",
      function()
        M.format({ force = true })
      end,
      mode = { "n", "x" },
      desc = "Format",
    },
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "x" },
      desc = "Format Injected Langs",
    },
  },
  init = function()
    -- Wire the engine up on VeryLazy: autoformat autocmd + commands, the conform
    -- formatter, formatexpr, and the autoformat toggles.
    Util.on_very_lazy(function()
      M.setup()

      M.register({
        name = "conform.nvim",
        priority = 100,
        primary = true,
        format = function(buf)
          require("conform").format({ bufnr = buf })
        end,
        sources = function(buf)
          local ret = require("conform").list_formatters(buf)
          ---@param v conform.FormatterInfo
          return vim.tbl_map(function(v)
            return v.name
          end, ret)
        end,
      })

      vim.o.formatexpr = "v:lua.require'util.format'.formatexpr()"

      M.snacks_toggle():map("<leader>uf")
      M.snacks_toggle(true):map("<leader>uF")
    end)
  end,
  -- A TABLE (not a function): lazy DEEP-MERGES it with the conform opts contributed by the
  -- lang/prettier files (which load before us). A function that returned a full table
  -- would REPLACE those instead, wiping their formatters_by_ft. This table also carries
  -- the base (lua/fish/sh, default_format_opts, injected) so it still stands alone.
  ---@type conform.setupOpts
  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_format = "fallback", -- not recommended to change
    },
    formatters_by_ft = {
      -- base
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        -- user
        ["java"] = { "prettier" },
        ["tsx"] = { "prettier" },
        ["htmlangular"] = { "prettier" },
        ["typescript"] = { "prettier" },
        ["xml"] = { "xmlformat" },
        ["cs"] = { "csharpier" },
        ["sql"] = { "sqruff" },
        ["markdown"] = { "markdown-toc" },
        ["markdown.mdx"] = { "markdown-toc" },
      },
      formatters = {
        -- base
        injected = { options = { ignore_errors = true } },
        -- user
        sqruff = {},
        prettier = {
          require_cwd = true,
          condition = function(_, ctx)
            local supported =
              { "javascript", "typescript", "css", "html", "htmlangular", "json", "java", "typescriptreact" }
            local ft = vim.bo[ctx.buf].filetype
            return vim.tbl_contains(supported, ft)
          end,
          -- Dont forget to npm install prettier and the java plugin
          cwd = function(self, ctx)
            local found = vim.fs.find({ "frontend" }, { upward = true, path = ctx.dirname })[1]
            if found then
              return found
            end
          end,
          append_args = { "--config", ".prettierrc.json" },
        },
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
      },
    },
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
