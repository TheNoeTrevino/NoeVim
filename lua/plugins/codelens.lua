return {
  "oribarilan/lensline.nvim",
  branch = "release/2.x",
  event = "LspAttach",
  config = function()
    require("lensline").setup({
      profiles = {
        {
          name = "minimal",
          providers = { -- Array format: order determines display sequence
            {
              name = "usages",
              enabled = true, -- enable usages provider by default (replaces references)
              include = { "refs" }, -- refs-only setup to match references provider behavior
              breakdown = true, -- false = aggregate count, true = breakdown by type
              show_zero = true, -- show zero counts when LSP supports the capability
              labels = {
                refs = "refs",
                impls = "impls",
                defs = "defs",
                usages = "usages",
              },
              icon_for_single = "󰌹 ", -- icon when only one attribute or aggregate display
              inner_separator = ", ", -- separator between breakdown items
            },
            {
              name = "last_author",
              enabled = true, -- enabled by default with caching optimization
              cache_max_files = 50, -- maximum number of files to cache blame data for (default: 50)
            },
            -- additional built-in or custom providers can be added here
          },
          style = {
            separator = " • ", -- separator between all lens attributes
            highlight = "Comment", -- highlight group for lens text
            prefix = "", -- prefix before lens content
            placement = "inline", -- "above" | "inline" - where to render lenses (consider prefix = "" for inline)
            use_nerdfont = true, -- enable nerd font icons in built-in providers
            render = "focused", -- "all" | "focused" (only active window's focused function)
          },
        },
        {
          name = "default",
          providers = { -- Array format: order determines display sequence
            {
              name = "usages",
              enabled = true, -- enable usages provider by default (replaces references)
              include = { "refs" }, -- refs-only setup to match references provider behavior
              breakdown = true, -- false = aggregate count, true = breakdown by type
              show_zero = true, -- show zero counts when LSP supports the capability
              labels = {
                refs = "refs",
                impls = "impls",
                defs = "defs",
                usages = "usages",
              },
              icon_for_single = "󰌹 ", -- icon when only one attribute or aggregate display
              inner_separator = ", ", -- separator between breakdown items
            },
            {
              name = "last_author",
              enabled = true, -- enabled by default with caching optimization
              cache_max_files = 50, -- maximum number of files to cache blame data for (default: 50)
            },
            -- additional built-in or custom providers can be added here
          },
          style = {
            separator = " • ", -- separator between all lens attributes
            highlight = "Comment", -- highlight group for lens text
            prefix = "┃ ", -- prefix before lens content
            placement = "above", -- "above" | "inline" - where to render lenses (consider prefix = "" for inline)
            use_nerdfont = true, -- enable nerd font icons in built-in providers
            render = "all", -- "all" | "focused" (only active window's focused function)
          },
        },
      },
    })
  end,
}
