-- mason.nvim. opts_extend keeps ensure_installed mergeable so the language files can append tools.
return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  -- `cmd = "Mason"` alone means setup() -- which prepends mason's bin/ to
  -- vim.env.PATH -- doesn't run until you open the Mason UI or something
  -- else pulls this in as a hard dependency (conform.nvim does, but only on
  -- the FIRST BufWritePre). A tool resolved by bare name over PATH (gopher.nvim's
  -- `:GoImpl`, `:GoTagAdd`, `:GoIfErr` all default to this) can lose that race:
  -- ft=go loads gopher.nvim the moment you open a .go file, before any save has
  -- happened, so the bin isn't found yet even if it's installed. VeryLazy runs
  -- setup() a beat after startup regardless, closing the gap.
  event = "VeryLazy",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  -- roslyn.nvim resolves its server binary via $MASON (see roslyn/utils.lua
  -- get_mason_path). It ft-loads on .cs before mason (cmd-lazy) runs setup(), so
  -- export $MASON at startup to match install_root_dir below; otherwise roslyn
  -- falls back to the default mason path and can't find the moved binary.
  init = function()
    if vim.fn.has("win32") == 1 then
      vim.env.MASON = "C:/mason"
    end
  end,
  opts_extend = { "ensure_installed" },
  opts = {
    -- Windows-only: the default mason root (~/AppData/Local/nvim-data/mason) makes
    -- roslyn's BuildHost-net472 exe path 270 chars, over MAX_PATH (260). CreateProcess
    -- then fails with "file not found" (Win32 err 2) even though the exe exists, so
    -- legacy .NET Framework projects silently fail to load and give no completions.
    -- A short root keeps the full path under the limit. nil = mason default on Linux/macOS.
    install_root_dir = vim.fn.has("win32") == 1 and "C:/mason" or nil,
    ensure_installed = {
      "black",
      "csharpier",
      "css-lsp",
      "gofumpt",
      "goimports",
      "jdtls",
      "markdown-toc",
      "prettier",
      "roslyn-language-server",
      "kulala-fmt",
      "stylua",
      "shfmt",
      "vtsls",
    },
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        -- trigger FileType event to possibly load this newly installed LSP server
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)

    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
}
