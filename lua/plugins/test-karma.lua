-- Neotest + DAP for Angular/Karma frontends. Zhunio/neotest-karma is a neotest-jest fork with
-- the jest bits half swapped out: discovery is answered from the cwd's package.json captured at
-- module load, and the run command is hardcoded to `npm run test:ci`. Neither fits a repo that
-- drives karma through the angular builder, so both are replaced here rather than in the repo.

--- The angular project root. `ng test` has to run from here, and --include is relative to it.
local function project_root(path)
  return require("neotest.lib").files.match_root_pattern("angular.json")(path)
end

return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "Zhunio/neotest-karma" },
    opts = function(_, opts)
      -- neotest-karma requires neotest.lib at module level, so requiring it here -- while
      -- neotest's own opts are still being evaluated -- can re-enter and fail with "loop or
      -- previous error loading module". Everything not overridden below is fetched on first
      -- touch instead, by which point neotest has finished loading.
      local karma
      local function upstream()
        karma = karma or require("neotest-karma")({})
        return karma
      end

      local adapter = setmetatable({ name = "neotest-karma" }, {
        __index = function(_, key)
          return upstream()[key]
        end,
      })

      adapter.root = project_root

      -- Upstream reads `vim.fn.getcwd() .. "/package.json"` when the module loads, so discovery
      -- silently finds nothing unless nvim happened to start in the angular project.
      adapter.is_test_file = function(file_path)
        return file_path:match("%.spec%.ts$") ~= nil and project_root(file_path) ~= nil
      end

      adapter.build_spec = function(args)
        local spec = upstream().build_spec(args)
        if not spec then
          return
        end

        local path = args.tree:data().path
        local root = project_root(path)
        if not root then
          return spec
        end

        local command = { "npx", "ng", "test", "--watch=false", "--browsers=ChromeHeadless" }
        -- A whole-suite run has no single file to narrow to, and pos.path is a directory there.
        if not args.suite then
          table.insert(command, "--include=" .. path:sub(#root + 2))
        end

        spec.command = command
        spec.cwd = root
        return spec
      end

      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, adapter)
    end,
  },

  -- Stepping through specs. The adapter has no dap strategy, so <leader>td will not work for
  -- karma; breakpoints go through the page karma serves at /debug.html instead. Start the runner
  -- in watch mode first (`npx ng test --include=...`, no --watch=false), then <leader>dc here.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")

      for _, ft in ipairs({ "typescript", "javascript" }) do
        dap.configurations[ft] = dap.configurations[ft] or {}
        table.insert(dap.configurations[ft], 1, {
          type = "pwa-chrome",
          request = "launch",
          name = "Karma: debug specs",
          url = "http://localhost:9876/debug.html",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
          -- The angular builder serves its bundles out of a virtual webpack folder, so without
          -- these a breakpoint set in the .spec.ts resolves to nothing.
          sourceMapPathOverrides = {
            ["webpack:///./*"] = "${webRoot}/*",
            ["webpack:///src/*"] = "${webRoot}/src/*",
            ["webpack:///*"] = "*",
          },
        })
      end
    end,
  },
}
