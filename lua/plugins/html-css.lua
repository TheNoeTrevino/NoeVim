return {
  {
    "Jezda1337/nvim-html-css",
    ft = { "html" },
    opts = {
      enable_on = { -- Example file types
        "html",
        "htmlangular",
        "tsx",
        "jsx",
      },
      handlers = {
        definition = {
          bind = "gd",
        },
        hover = {
          bind = ")",
          wrap = true,
          border = "none",
          position = "right",
        },
      },
      documentation = {
        auto_show = true,
      },
      style_sheets = {
        "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
        "https://cdnjs.cloudflare.com/ajax/libs/bulma/1.0.3/css/bulma.min.css",
        "./styles.css", -- `./` refers to the current working directory.
        "./styles.scss", -- `./` refers to the current working directory.
        "node_modules/bootstrap/dist/js/bootstrap.bundle.min.js",
      },
    },
  },
  {
    "saghen/blink.compat",
    version = "*",
    lazy = true, -- Automatically loads when required by blink.cmp
    opts = {},
  },
}
