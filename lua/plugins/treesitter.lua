-- Treesitter specs, re-derived from LazyVim's base so this config no longer
-- depends on the LazyVim distro. The `nvim-treesitter`, `-textobjects` and
-- `nvim-ts-autotag` entries below carry LazyVim's base opts and load timing;
-- the original `treesitter-modules.nvim` override (with the user's
-- incremental_selection keymaps) is kept at the bottom.

local Util = require("util")

-- Local re-implementation of the bits of `lazyvim.util.treesitter` and
-- `Util.set_default` that the base config relied on, with the Util.*
-- coupling stripped out.
local TSUtil = {}

TSUtil._installed = nil ---@type table<string,boolean>?
TSUtil._queries = {} ---@type table<string,boolean>

---@param update boolean?
function TSUtil.get_installed(update)
  if update then
    TSUtil._installed, TSUtil._queries = {}, {}
    for _, lang in ipairs(require("nvim-treesitter").get_installed("parsers")) do
      TSUtil._installed[lang] = true
    end
  end
  return TSUtil._installed or {}
end

---@param lang string
---@param query string
function TSUtil.have_query(lang, query)
  local key = lang .. ":" .. query
  if TSUtil._queries[key] == nil then
    TSUtil._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
  end
  return TSUtil._queries[key]
end

---@param what string|number|nil
---@param query? string
---@return boolean
function TSUtil.have(what, query)
  what = what or vim.api.nvim_get_current_buf()
  what = type(what) == "number" and vim.bo[what].filetype or what --[[@as string]]
  local lang = vim.treesitter.language.get_lang(what)
  if lang == nil or TSUtil.get_installed()[lang] == nil then
    return false
  end
  if query and not TSUtil.have_query(lang, query) then
    return false
  end
  return true
end

function TSUtil.foldexpr()
  return TSUtil.have(nil, "folds") and vim.treesitter.foldexpr() or "0"
end

function TSUtil.indentexpr()
  return TSUtil.have(nil, "indents") and require("nvim-treesitter").indentexpr() or -1
end

-- Expose fold/indent expr helpers globally so the `foldexpr`/`indentexpr`
-- option strings below can reach them (option exprs are evaluated as global
-- vimscript and can't see this file's local `TSUtil`).
_G.ConfigTreesitter = TSUtil

-- Health check for the treesitter `main` branch build requirements.
---@return boolean ok, table<string,boolean> health
function TSUtil.check()
  local is_win = vim.fn.has("win32") == 1
  local function have(tool, win)
    return (win == nil or is_win == win) and vim.fn.executable(tool) == 1
  end

  local have_cc = vim.env.CC ~= nil or have("cc", false) or have("cl", true)
  if not have_cc and is_win and vim.fn.executable("gcc") == 1 then
    vim.env.CC = "gcc"
    have_cc = true
  end

  local ret = {
    ["tree-sitter (CLI)"] = have("tree-sitter"),
    ["C compiler"] = have_cc,
    tar = have("tar"),
    curl = have("curl"),
  }
  local ok = true
  for _, v in pairs(ret) do
    ok = ok and v
  end
  return ok, ret
end

---@param cb fun(ok:boolean, err?:string)
function TSUtil.ensure_treesitter_cli(cb)
  if vim.fn.executable("tree-sitter") == 1 then
    return cb(true)
  end

  if not pcall(require, "mason") then
    return cb(false, "`mason.nvim` is disabled in your config, so we cannot install it automatically.")
  end

  if vim.fn.executable("tree-sitter") == 1 then
    return cb(true)
  end

  local mr = require("mason-registry")
  mr.refresh(function()
    local p = mr.get_package("tree-sitter-cli")
    if not p:is_installed() then
      Util.info("Installing `tree-sitter-cli` with `mason.nvim`...")
      p:install(
        nil,
        vim.schedule_wrap(function(success)
          if success then
            Util.info("Installed `tree-sitter-cli` with `mason.nvim`.")
            cb(true)
          else
            cb(false, "Failed to install `tree-sitter-cli` with `mason.nvim`.")
          end
        end)
      )
    end
  end)
end

---@param cb fun()
function TSUtil.build(cb)
  TSUtil.ensure_treesitter_cli(function(_, err)
    local ok, health = TSUtil.check()
    if ok then
      return cb()
    end
    local lines = { "Unmet requirements for **nvim-treesitter** `main`:" }
    local keys = vim.tbl_keys(health) ---@type string[]
    table.sort(keys)
    for _, k in pairs(keys) do
      lines[#lines + 1] = ("- %s `%s`"):format(health[k] and "✅" or "❌", k)
    end
    vim.list_extend(lines, {
      "",
      "See the requirements at [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#requirements)",
      "Run `:checkhealth nvim-treesitter` for more information.",
    })
    if vim.fn.has("win32") == 1 and not health["C compiler"] then
      lines[#lines + 1] = "Install a C compiler with `winget install --id=BrechtSanders.WinLibs.POSIX.UCRT -e`"
    end
    vim.list_extend(lines, err and { "", err } or {})
    Util.error(lines, { title = "Treesitter" })
  end)
end

-- Set a local option only if it still holds its default/global value, so we
-- don't clobber a value the user (or another plugin) explicitly set.
---@param option string
---@param value string|number|boolean
---@return boolean was_set
local function set_default(option, value)
  local l = vim.api.nvim_get_option_value(option, { scope = "local" })
  local g = vim.api.nvim_get_option_value(option, { scope = "global" })
  local info = vim.api.nvim_get_option_info2(option, {})
  -- Only set when the local value matches the global default, i.e. it hasn't
  -- been customized for this buffer/window already.
  if l == g or l == info.default then
    vim.api.nvim_set_option_value(option, value, { scope = "local" })
    return true
  end
  return false
end

return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
    version = false, -- last release is way too old and doesn't work on Windows
    build = function()
      local TS = require("nvim-treesitter")
      if not TS.get_installed then
        Util.error("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.")
        return
      end
      TSUtil.build(function()
        TS.update(nil, { summary = true })
      end)
    end,
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter")

      setmetatable(require("nvim-treesitter.install"), {
        __newindex = function(_, k)
          if k == "compilers" then
            vim.schedule(function()
              Util.error({
                "Setting custom compilers for `nvim-treesitter` is no longer supported.",
                "",
                "For more info, see:",
                "- [compilers](https://docs.rs/cc/latest/cc/#compile-time-requirements)",
              })
            end)
          end
        end,
      })

      -- some quick sanity checks
      if not TS.get_installed then
        return Util.error("Please use `:Lazy` and update `nvim-treesitter`")
      elseif type(opts.ensure_installed) ~= "table" then
        return Util.error("`nvim-treesitter` opts.ensure_installed must be a table")
      end

      -- setup treesitter
      TS.setup(opts)
      TSUtil.get_installed(true) -- initialize the installed langs

      -- install missing parsers
      local install = vim.tbl_filter(function(lang)
        return not TSUtil.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        TSUtil.build(function()
          TS.install(install, { summary = true }):await(function()
            TSUtil.get_installed(true) -- refresh the installed langs
          end)
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("config_treesitter", { clear = true }),
        callback = function(ev)
          local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          if not TSUtil.have(ft) then
            return
          end

          ---@param feat string
          ---@param query string
          local function enabled(feat, query)
            local f = opts[feat] or {}
            return f.enable ~= false
              and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
              and TSUtil.have(ft, query)
          end

          -- highlighting
          if enabled("highlight", "highlights") then
            pcall(vim.treesitter.start, ev.buf)
          end

          -- indents
          if enabled("indent", "indents") then
            set_default("indentexpr", "v:lua.ConfigTreesitter.indentexpr()")
          end

          -- folds
          if enabled("folds", "folds") then
            if set_default("foldmethod", "expr") then
              set_default("foldexpr", "v:lua.ConfigTreesitter.foldexpr()")
            end
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        -- buffer-local move keymaps
        keys = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter-textobjects")
      if not TS.setup then
        Util.error("Please use `:Lazy` and update `nvim-treesitter`")
        return
      end
      TS.setup(opts)

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not (vim.tbl_get(opts, "move", "enable") and TSUtil.have(ft, "textobjects")) then
          return
        end
        ---@type table<string, table<string, string>>
        local moves = vim.tbl_get(opts, "move", "keys") or {}

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local queries = type(query) == "table" and query or { query }
            local parts = {}
            for _, q in ipairs(queries) do
              local part = q:gsub("@", ""):gsub("%..*", "")
              part = part:sub(1, 1):upper() .. part:sub(2)
              table.insert(parts, part)
            end
            local desc = table.concat(parts, " or ")
            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
            vim.keymap.set({ "n", "x", "o" }, key, function()
              if vim.wo.diff and key:find("[cC]") then
                return vim.cmd("normal! " .. key)
              end
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, {
              buffer = buf,
              desc = desc,
              silent = true,
            })
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("config_treesitter_textobjects", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },

  -- User override: incremental selection keymaps via treesitter-modules.
  {
    "MeanderingProgrammer/treesitter-modules.nvim",
    lazy = true,
    opts = {
      -- fold = {
      --   enable = true,
      -- },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = false, -- set to `false` to disable one of the mappings
          node_incremental = "<CR>",
          node_decremental = "<bs>",
          scope_incremental = "<tab>",
        },
        indent = {
          enable = true,
        },
      },
    },
  },
}
