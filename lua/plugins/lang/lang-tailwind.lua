-- Only start tailwindcss where the project actually uses Tailwind.
--
-- nvim-lspconfig's default root_dir ends its marker list with `.git`, a
-- deliberate fallback for Tailwind v4 (which no longer requires
-- tailwind.config.*). The side effect is that the server attaches in *any* git
-- repo with a matching filetype and serves Tailwind's built-in default
-- utilities, so a Bootstrap project gets completions and hover docs for classes
-- that will never be generated. That is how `my-px` reached an icris template:
-- accepted from a completion popup, it compiles to nothing.
--
-- Require real evidence instead. Every genuine Tailwind project installs the
-- package -- v4's CSS-first config still needs `tailwindcss` in the manifest --
-- so a dependency check covers v3 and v4 alike, with the config file as the
-- fast path and lockfiles for stacks that have no package.json.

local CONFIG_FILES = {
  "tailwind.config.js",
  "tailwind.config.cjs",
  "tailwind.config.mjs",
  "tailwind.config.ts",
}

local MANIFESTS = { "package.json", "mix.lock", "Gemfile.lock" }

---@type table<string, string|false>
local cache = {}

---@param path string
---@return boolean
local function declares_tailwind(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or type(lines) ~= "table" then
    return false
  end
  local text = table.concat(lines, "\n")

  if vim.fs.basename(path) == "package.json" then
    -- Read the dependency lists rather than substring-matching the whole file,
    -- so an unrelated `"build:tailwind"` script can't start the server. A
    -- manifest that parses and has no tailwind dep is a real answer: keep
    -- walking up, since a monorepo may declare it at the root.
    local decoded, pkg = pcall(vim.json.decode, text)
    if decoded and type(pkg) == "table" then
      for _, field in ipairs({ "dependencies", "devDependencies", "peerDependencies" }) do
        for name in pairs(pkg[field] or {}) do
          if name == "tailwindcss" or name:match("^@tailwindcss/") then
            return true
          end
        end
      end
      return false
    end
  end

  return text:find("tailwind", 1, true) ~= nil
end

---@param fname string
---@return string? root nil means "do not start the server"
local function detect_root(fname)
  local cfg = vim.fs.find(CONFIG_FILES, { path = fname, upward = true })[1]
  if cfg then
    return vim.fs.dirname(cfg)
  end
  for _, manifest in ipairs(MANIFESTS) do
    for _, found in ipairs(vim.fs.find(manifest, { path = fname, upward = true, limit = math.huge })) do
      if declares_tailwind(found) then
        return vim.fs.dirname(found)
      end
    end
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          -- Not calling on_dir is what keeps the client from starting at all.
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            if fname == "" then
              return
            end
            local dir = vim.fs.dirname(fname)
            if cache[dir] == nil then
              cache[dir] = detect_root(fname) or false
            end
            if cache[dir] then
              on_dir(cache[dir])
            end
          end,

          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          filetypes_include = {},
          -- to fully override the default_config, change the below
          -- filetypes = {}

          -- additional settings for the server, e.g:
          -- tailwindCSS = { includeLanguages = { someLang = "html" } }
          -- can be addeded to the settings table and will be merged with
          -- this defaults for Phoenix projects
          settings = {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          },
        },
      },
      setup = {
        tailwindcss = function(_, opts)
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, vim.lsp.config.tailwindcss.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
    },
    opts = function(_, opts)
      -- original Util kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
  },
}
