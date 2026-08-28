return {
  -- Razor/Blazor + C# LSP via Roslyn co-hosting.
  --
  -- rzls.nvim is DEPRECATED: Razor/cshtml support is now built into the Roslyn
  -- language server ("co-hosting"), so roslyn.nvim alone drives both .cs and
  -- .razor. DevExpress (and any NuGet) components complete automatically once
  -- Roslyn sees the project's references — there is no separate completion source.
  --
  -- roslyn.nvim auto-detects the mason binary `roslyn-language-server` (see
  -- lua/roslyn/utils.lua get_roslyn_lsp_path), which is installed via mason.lua's
  -- ensure_installed. Razor requires server >= 5.8.0-1.26262.10 (satisfied).
  -- OmniSharp is disabled in lang-dotnet.lua so the two don't fight over .cs.
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- defaults; Razor co-hosting needs no extra args
    },
    init = function()
      -- Register Razor filetypes before the plugin loads so `ft` triggers and
      -- Roslyn attaches to them.
      vim.filetype.add({
        extension = {
          razor = "razor",
          cshtml = "razor",
        },
      })

      -- Perf: Roslyn answers these two cursor-movement-triggered requests slowly
      -- on large .razor files, which freezes the UI while moving around. Disable
      -- them for the Roslyn client only (other languages keep folds + word-hl).
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "roslyn" then
            return
          end
          -- 1. LSP folding: stop foldexpr from re-querying Roslyn on every move.
          client.server_capabilities.foldingRangeProvider = false
          if vim.wo.foldexpr:find("lsp") then
            vim.wo.foldmethod = "manual"
          end
          -- 2. Document highlight (Snacks words) on CursorHold.
          client.server_capabilities.documentHighlightProvider = false
        end,
      })
    end,
  },
  -- Syntax/indent for .razor (LSP handles completion; this handles highlighting).
  { "jlcrochet/vim-razor" },
}
