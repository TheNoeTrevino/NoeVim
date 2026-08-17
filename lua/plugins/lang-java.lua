local Util = require("util")
-- This is the same as in lspconfig.configs.jdtls, but avoids
-- needing to require that when this module loads.
local java_filetypes = { "java" }

-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
local function extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
  end
  return config
end

return {
  -- Add java to treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "java" } },
  },

  -- Ensure java debugger and test packages are installed.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      -- Simple configuration to attach to remote java debug process
      -- Taken directly from https://github.com/mfussenegger/nvim-dap/wiki/Java
      local dap = require("dap")
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }
    end,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "java-debug-adapter", "java-test" } },
      },
    },
  },

  -- Configure nvim-lspconfig to install the server automatically via mason, but
  -- defer actually starting it to our configuration of nvim-jtdls below.
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        jdtls = {},
      },
      setup = {
        jdtls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },

  -- Set up nvim-jdtls to attach to java files.
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "folke/which-key.nvim" },
    ft = java_filetypes,
    opts = function()
      local cmd = { vim.fn.exepath("jdtls") }
      if Util.has("mason.nvim") then
        local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
        table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
      end
      return {
        root_dir = function(path)
          return vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
        end,

        -- How to find the project name for a given root dir.
        -- Keyed by <parent>-<basename> rather than basename alone: git worktrees
        -- all share the same basename (e.g. "backend"), so basename-only keying
        -- made every worktree collide on one jdtls workspace and corrupt each
        -- other's index when switching trees.
        project_name = function(root_dir)
          if not root_dir then
            return nil
          end
          return vim.fn.fnamemodify(root_dir, ":h:t") .. "-" .. vim.fs.basename(root_dir)
        end,

        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,

        -- How to run jdtls. This can be overridden to a full java command-line
        -- if the Python wrapper script doesn't suffice.
        cmd = cmd,
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd = vim.deepcopy(opts.cmd)
          if project_name then
            vim.list_extend(cmd, {
              "-configuration",
              opts.jdtls_config_dir(project_name),
              "-data",
              opts.jdtls_workspace_dir(project_name),
            })
          end
          return cmd
        end,

        -- These depend on nvim-dap, but can additionally be disabled by setting false here.
        dap = { hotcodereplace = "auto", config_overrides = {} },
        -- Can set this to false to disable main class scan, which is a performance killer for large project
        dap_main = {},
        test = true,
        settings = {
          java = {
            inlayHints = {
              parameterNames = {
                enabled = "all",
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      -- Find the extra bundles that should be passed on the jdtls command-line
      -- if nvim-dap is enabled with java debug/test.
      local bundles = {} ---@type string[]
      if Util.has("mason.nvim") then
        local mason_registry = require("mason-registry")
        if opts.dap and Util.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
          bundles = vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*jar", false, true)
          -- java-test also depends on java-debug-adapter.
          if opts.test and mason_registry.is_installed("java-test") then
            vim.list_extend(bundles, vim.fn.glob("$MASON/share/java-test/*.jar", false, true))
          end
        end
      end
      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)

        -- Configuration can be augmented and overridden by opts.jdtls
        local config = extend_or_override({
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          init_options = {
            bundles = bundles,
          },
          settings = opts.settings,
          -- enable CMP capabilities
          capabilities = Util.has("blink.cmp") and require("blink.cmp").get_lsp_capabilities() or Util.has(
            "cmp-nvim-lsp"
          ) and require("cmp_nvim_lsp").default_capabilities() or nil,
        }, opts.jdtls)

        -- Existing server will be reused if the root_dir matches.
        require("jdtls").start_or_attach(config)
        -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
      end

      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = java_filetypes,
        callback = attach_jdtls,
      })

      -- Setup keymap and dap after the lsp is fully attached.
      -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
      -- https://neovim.io/doc/user/lsp.html#LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            local wk = require("which-key")
            wk.add({
              {
                mode = "n",
                buffer = args.buf,
                { "<leader>cx", group = "extract" },
                { "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
                { "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant" },
                { "<leader>cgs", require("jdtls").super_implementation, desc = "Goto Super" },
                { "<leader>cgS", require("jdtls.tests").goto_subjects, desc = "Goto Subjects" },
                { "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports" },
              },
            })
            wk.add({
              {
                mode = "x",
                buffer = args.buf,
                { "<leader>cx", group = "extract" },
                {
                  "<leader>cxm",
                  [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                  desc = "Extract Method",
                },
                {
                  "<leader>cxv",
                  [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
                  desc = "Extract Variable",
                },
                {
                  "<leader>cxc",
                  [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                  desc = "Extract Constant",
                },
              },
            })

            if Util.has("mason.nvim") then
              local mason_registry = require("mason-registry")
              if opts.dap and Util.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
                -- custom init for Java debugger
                require("jdtls").setup_dap(opts.dap)
                if opts.dap_main then
                  require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
                end

                -- opts.test only controls whether the java-test bundles are handed to jdtls
                -- (done above). The <leader>t* keymaps that used to live here are gone:
                -- neotest-java owns that prefix now, and buffer-local jdtls maps shadowed it.
              end
            end

            -- User can set additional keymaps in opts.on_attach
            if opts.on_attach then
              opts.on_attach(args)
            end
          end
        end,
      })

      -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
      attach_jdtls()
    end,
  },

  -- Test discovery/running. The module returned by neotest-java is already a fully built
  -- adapter (its __call only rebuilds it with different options), so it is registered with an
  -- empty config table -- test-core.lua's loader passes those straight through untouched.
  -- Defaults already cover this repo: *Tests/*IT/*Spec classnames, gradle kotlin DSL, junit5.
  {
    "nvim-neotest/neotest",
    optional = true,
    -- nvim-jdtls is deliberately not a dependency here. neotest-java never requires it, it only
    -- looks for a running client via vim.lsp.get_clients({ name = "jdtls" }), which the ft
    -- trigger on the jdtls spec above already provides in java buffers. Listing it would make
    -- lazy.nvim load it whenever neotest loads, so opening the summary in a Go or TS repo would
    -- run attach_jdtls() against a non-java buffer and spawn a JVM for a project with no java.
    dependencies = {
      "rcasia/neotest-java",
    },
    opts = function(_, opts)
      local adapter = require("neotest-java")

      -- neotest-java's root_finder wants .git and a build file in the same directory, else the
      -- nearest build file searching *upward*, else .git alone. This repo has gradle under
      -- backend/ and .git at the top, so starting nvim at the repo root hits the last case and
      -- roots everything there. That is not cosmetic: the gradle build tool resolves its build
      -- dir as <root>/bin, so it reads the empty repo-root bin/ instead of backend/bin/, where
      -- the classes and junit-reports actually are. Prefer a descendant holding the build file.
      -- root_finder itself is injectable only as __call's second argument, which test-core's
      -- loader never passes, so the override goes on the adapter.
      local function has_build_file(dir)
        for _, name in ipairs({ "settings.gradle", "settings.gradle.kts", "pom.xml" }) do
          if vim.uv.fs_stat(dir .. "/" .. name) then
            return true
          end
        end
        return false
      end

      local upstream_root = adapter.root
      adapter.root = function(dir)
        local root = upstream_root(dir)
        if not root or has_build_file(root) then
          return root
        end
        -- Immediate children only. A recursive search would walk frontend/node_modules, and a
        -- build file further down than this is a layout worth rooting nvim inside of anyway.
        -- First match wins, so a repo with sibling JVM projects still needs nvim opened in one.
        for name, entry_type in vim.fs.dir(root) do
          if entry_type == "directory" and has_build_file(root .. "/" .. name) then
            return root .. "/" .. name
          end
        end
        return root
      end

      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, adapter)
    end,
  },
}
