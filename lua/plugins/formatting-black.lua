return {
  {
    "mason-org/mason.nvim",
    -- table form composes with mason's opts_extend = { "ensure_installed" }.
    opts = { ensure_installed = { "black" } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { "black" },
      },
    },
  },
}
