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
      -- Load upstream here, on the main loop, and not on first touch. neotest-karma calls
      -- `vim.tbl_flatten` (deprecated, so nvim echoes a warning) and `vim.fn.getcwd()` while
      -- its modules load, and neither call is legal in a fast event context. Neotest first
      -- touches an adapter field from inside an nio task (client/init.lua:277, filter_dir), so
      -- a deferred load dies there with "E5560: nvim_echo must not be called in a fast event
      -- context". Lua leaves the half-loaded module marked in package.loaded, so every later
      -- require reports "loop or previous error loading module 'neotest-karma'" until nvim
      -- restarts. This spec is imported after plugins.lang, and lazy.nvim loads the
      -- Zhunio/neotest-karma dependency before it evaluates these opts, so the require is safe.
      local karma = require("neotest-karma")({})

      -- Upstream hands neotest the string 'require("neotest-karma").build_position', and a
      -- string build_position tells neotest to parse the file in its child nvim
      -- (neotest/lib/treesitter/init.lua:180). The child then loads neotest-karma inside an
      -- async remote call, and the deprecated `vim.tbl_flatten` in neotest-karma/util.lua:158
      -- echoes a warning there. That echo never returns in the child, so the reply never
      -- arrives and the parse blocks forever: karma files appear in the summary with zero
      -- tests, and a run reports no per-test results. Passing the function keeps the parse in
      -- this process, which neotest supports for exactly this case. The guard leaves every
      -- other adapter's parse untouched, so the wrapper is installed once and never removed.
      local treesitter = require("neotest.lib").treesitter
      if not treesitter.karma_parses_in_process then
        treesitter.karma_parses_in_process = true
        local parse_positions = treesitter.parse_positions
        treesitter.parse_positions = function(file_path, query, options)
          if options and options.build_position == 'require("neotest-karma").build_position' then
            options = vim.tbl_extend("force", options, { build_position = karma.build_position })
          end
          return parse_positions(file_path, query, options)
        end
      end

      local adapter = setmetatable({ name = "neotest-karma" }, { __index = karma })

      adapter.root = project_root

      -- Upstream reads `vim.fn.getcwd() .. "/package.json"` when the module loads, so discovery
      -- silently finds nothing unless nvim happened to start in the angular project.
      adapter.is_test_file = function(file_path)
        return file_path:match("%.spec%.ts$") ~= nil and project_root(file_path) ~= nil
      end

      adapter.build_spec = function(args)
        local spec = karma.build_spec(args)
        if not spec then
          return
        end

        local pos = args.tree:data()
        local path = pos.path
        local root = project_root(path)
        -- Falling through to the upstream spec would run jest's hardcoded `npm run test:ci`
        -- from its own cwd, which is not this project and usually not even a test command.
        -- Nothing sensible to run, so run nothing.
        if not root then
          return
        end

        local command = { "npx", "ng", "test", "--watch=false", "--browsers=ChromeHeadless" }
        -- Narrow to the position, unless it is a directory -- there is no single file to name,
        -- and for the project root itself the relative path is empty, which --include rejects.
        -- Keyed off pos.type rather than args.suite: neotest only sets suite for an explicit
        -- run.run({ suite = true }), and <leader>tT passes a path instead (run.lua:26).
        if pos.type ~= "dir" then
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
