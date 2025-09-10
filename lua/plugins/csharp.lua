return {
  "seblyng/roslyn.nvim",
  event = "VeryLazy",
  opts = {
    settings = {
      ["csharp|inlay_hints"] = {
        csharp_enable_inlay_hints_for_implicit_object_creation = true,
        csharp_enable_inlay_hints_for_implicit_variable_types = true,
      },
      ["csharp|code_lens"] = {
        dotnet_enable_references_code_lens = true,
      },
    },
  },
  config = function(_, opts)
    -- if this isnt working, remember to get the lsp from mason like below
    require("mason").setup({
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    })
  end,
}
