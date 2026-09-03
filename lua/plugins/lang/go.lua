-- Go language support: the LSP/treesitter/mason/dap/neotest stack plus the gopher.nvim spec.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          init_options = {
            semanticTokens = true,
          },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            },
          },
        },
        -- Replaces nvim-lint's golangcilint: this one resolves go.mod by
        -- walking up from the SAVED FILE's own path (handler.go, not this
        -- editor's cwd or root_dir) and lints that file's package
        -- directory rather than the single file -- the scope a
        -- depguard/typecheck-style finding actually needs. Default
        -- init_options already targets golangci-lint v2's JSON flags and
        -- falls back to v1 on its own; no override needed here.
        golangci_lint_ls = {},
      },
      setup = {
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          Snacks.util.lsp.on({ name = "gopls" }, function(_, client)
            if
              client.config
              and client.config.init_options
              and client.config.init_options.semanticTokens
              and not client.server_capabilities.semanticTokensProvider
            then
              local semantic = client.config.capabilities.textDocument.semanticTokens
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end)
          -- end workaround
        end,
      },
    },
  },
  -- Ensure Go tools are installed
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "goimports", "gofumpt", "gomodifytags", "impl" } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        -- conform's builtin gofumpt sets no `cwd`, so it runs from
        -- vim.fn.getcwd() -- the monorepo root in a repo like tremolo,
        -- which has no go.mod of its own. Without a go.mod to read,
        -- gofumpt can't tell "sight-reading/..." from a stdlib import and
        -- COLLAPSES the import groups instead of splitting them: the
        -- opposite of running it from inside core-api/, and the opposite
        -- of what the repo's own tooling does. Point it at the nearest
        -- go.mod instead, same as goimports' `-srcdir $DIRNAME` already
        -- does for itself via its builtin args.
        gofumpt = {
          cwd = require("conform.util").root_file({ "go.mod" }),
        },
      },
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "delve" } },
      },
      {
        "leoluz/nvim-dap-go",
        opts = {
          -- Attach to a headless delve instance you start yourself, the
          -- Go analog of `--debug-jvm`: run `dlv debug --headless
          -- --listen=:2345 --api-version=2 --accept-multiclient .` from
          -- core-api/, then pick "Attach remote" from the <leader>dc menu.
          dap_configurations = {
            {
              type = "go",
              name = "Attach remote",
              mode = "remote",
              request = "attach",
              host = "127.0.0.1",
              port = 2345,
            },
          },
        },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "fredrikaverpil/neotest-golang",
    },
    opts = {
      adapters = {
        ["neotest-golang"] = {
          -- Here we can set options for neotest-golang, e.g.
          -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
          dap_go_enabled = true, -- requires leoluz/nvim-dap-go
        },
      },
    },
  },

  -- Filetype icons
  {
    "nvim-mini/mini.icons",
    opts = {
      file = {
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
    },
  },

  -- gopher.nvim: extra Go tooling (tags, tests, iferr, etc.)
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    -- branch = "develop", -- if you want develop branch
    -- keep in mind, it might break everything
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
    },
    -- (optional) will update plugin's deps on every update
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    ---@type gopher.Config
    opts = {},

    config = function(_, opts)
      require("gopher").setup(opts)
      local map = Util.safe_keymap_set
      -- Tags (fatih/gomodifytags)
      map("n", "<leader>glj", "<cmd>GoTagAdd json<cr>", { desc = "Add JSON Tag" })
      map("n", "<leader>glJ", "<cmd>GoTagRm json<cr>", { desc = "Rm JSON Tag" })
      map("n", "<leader>gld", "<cmd>GoTagAdd db<cr>", { desc = "Add DB Tag" })
      map("n", "<leader>glD", "<cmd>GoTagRm db<cr>", { desc = "Rm DB Tag" })
      map("n", "<leader>glv", "<cmd>GoTagAdd validate<cr>", { desc = "Add Validate Tag" })
      map("n", "<leader>glV", "<cmd>GoTagRm validate<cr>", { desc = "Rm Validate Tag" })
      -- Interface stubs (josharian/impl) -- cursor on the struct, then the
      -- interface to implement; see gopher.nvim's :help gopher.nvim-impl
      -- for the receiver-and-struct-name explicit form.
      map("n", "<leader>gli", ":GoImpl ", { desc = "Implement Interface" })
      -- Other
      map("n", "<leader>glta", "<cmd>GoTestAdd<cr>", { desc = "Add Test for Function" })
      map("n", "<leader>gltA", "<cmd>GoTestsAll<cr>", { desc = "Generate All Tests" })
      map("n", "<leader>glg", ":GoGet", { desc = "Get Package" })
      map("n", "<leader>glT", "<cmd>GoMod tidy<cr>", { desc = "Go Tidy" })
      map("n", "<leader>gls", "<cmd>GoWork sync<cr>", { desc = "Go Sync" })
      map("n", "<leader>gle", "<cmd>GoIfErr<cr>", { desc = "Handle Err" })
    end,
  },
}
