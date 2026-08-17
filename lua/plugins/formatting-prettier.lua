local Util = require("util")
---@diagnostic disable: inject-field

---@alias ConformCtx {buf: number, filename: string, dirname: string}
local M = {}

local supported = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "htmlangular",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

--- Checks if a Prettier config file exists for the given context
---@param ctx ConformCtx
function M.has_config(ctx)
  vim.fn.system({ "prettier", "--find-config-path", ctx.filename })
  return vim.v.shell_error == 0
end

-- Asks prettier itself. MUST run in the same cwd the formatter will use: prettier
-- resolves a .prettierrc.json's `plugins` relative to the cwd rather than to the config,
-- so probing from anywhere but that workspace dies on prettier-plugin-java, writes an
-- error instead of json, and every unlisted filetype under it reports "Condition failed".
-- Takes plain strings, not the ctx/self tables, so the memoize key stays small.
---@param cwd string?
---@param filename string
function M.infers_parser(cwd, filename)
  local spawned, proc = pcall(function()
    return vim.system({ "prettier", "--file-info", filename }, { cwd = cwd, text = true }):wait()
  end)
  if not spawned then
    return false
  end
  ---@type boolean, string?
  local ok, parser = pcall(function()
    return vim.fn.json_decode(proc.stdout or "").inferredParser
  end)
  return ok and parser and parser ~= vim.NIL
end

--- Checks if a parser can be inferred for the given context:
--- * If the filetype is in the supported list, return true
--- * Otherwise, check if a parser can be inferred
---@param self conform.FormatterConfig
---@param ctx ConformCtx
function M.has_parser(self, ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  -- default filetypes are always supported
  if vim.tbl_contains(supported, ft) then
    return true
  end
  -- otherwise, check if a parser can be inferred
  return M.infers_parser(self.cwd and self.cwd(self, ctx) or nil, ctx.filename)
end

M.has_config = Util.memoize(M.has_config)
M.infers_parser = Util.memoize(M.infers_parser)

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "prettier" } },
  },

  -- conform
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- guarded: format.lua already lists prettier for some of these (typescript,
      -- htmlangular, ...), and a blind insert would run it twice on every save
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        if not vim.tbl_contains(opts.formatters_by_ft[ft], "prettier") then
          table.insert(opts.formatters_by_ft[ft], "prettier")
        end
      end

      opts.formatters = opts.formatters or {}
      -- "keep", not a plain assignment: lazy runs opts FUNCTIONS after merging the opts
      -- TABLES, so assigning here would wipe the prettier override format.lua
      -- contributes (its cwd/append_args). Only fill in what it doesn't set.
      opts.formatters.prettier = vim.tbl_deep_extend("keep", opts.formatters.prettier or {}, {
        condition = function(self, ctx)
          -- prettier can't infer a parser for .java on its own (the plugin lives in a
          -- project's frontend/), so has_parser always says no. Defer to cwd instead:
          -- java is formattable exactly where format.lua found a config to run under.
          if vim.bo[ctx.buf].filetype == "java" then
            return self.cwd ~= nil and self.cwd(self, ctx) ~= nil
          end
          return M.has_parser(self, ctx) and (vim.g.lazyvim_prettier_needs_config ~= true or M.has_config(ctx))
        end,
      })
    end,
  },

  -- none-ls support
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.prettier)
    end,
  },
}
