-- legacy-razor: full language support (hover, completion, document-highlight,
-- diagnostics) for classic ASP.NET MVC (System.Web) Razor views, via a
-- Roslyn-backed LSP server. Local plugin (~/projects/legacy-razor).
-- Windows-only: the server targets net472 and needs the .NET Framework; on
-- Linux/macOS this spec is disabled entirely.
return {
  {
    dir = vim.fs.normalize("~/projects/legacy-razor.nvim/"),
    enabled = vim.fn.has("win32") == 1,
    ft = "razor",
    cmd = "LegacyRazorCheck",
    build = "dotnet build -c Release server/LegacyRazor.Server.csproj",
    keys = {
      { "<leader>cV", "<cmd>LegacyRazorCheck<cr>", desc = "Check all Razor views (legacy-razor)" },
    },
    opts = {},
  },
}
