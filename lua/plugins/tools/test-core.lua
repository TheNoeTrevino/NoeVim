local Util = require("util")

--- Position types neotest itself understands. See neotest.types.PositionType.
local known_position_types = { dir = true, file = true, namespace = true, test = true }

--- Adapters come from `require`, so the same table is handed back on every setup. Anything
--- reloading neotest (`:Lazy reload`) re-runs config and would wrap already-wrapped methods
--- a second time. Weak keys so a dropped adapter is still collectable.
local claimed_wrapped = setmetatable({}, { __mode = "k" })
local positions_wrapped = setmetatable({}, { __mode = "k" })

return {
  desc = "Neotest support. Requires language specific adapters to be configured. (see lang extras)",
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/nvim-nio" },
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {},
      -- Example for loading neotest-golang with a custom config
      -- adapters = {
      --   ["neotest-golang"] = {
      --     go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
      --     dap_go_enabled = true,
      --   },
      -- },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          if Util.has("trouble.nvim") then
            require("trouble").open({ mode = "quickfix", focus = false })
          else
            vim.cmd("copen")
          end
        end,
      },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if Util.has("trouble.nvim") then
        opts.consumers = opts.consumers or {}
        -- Refresh and auto close trouble after running tests
        ---@type neotest.Consumer
        opts.consumers.trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end
            local tree = assert(client:get_position(nil, { adapter = adapter_id }))

            local failed = 0
            for pos_id, result in pairs(results) do
              if result.status == "failed" and tree:get_key(pos_id) then
                failed = failed + 1
              end
            end
            vim.schedule(function()
              local trouble = require("trouble")
              if trouble.is_open() then
                trouble.refresh()
                if failed == 0 then
                  trouble.close()
                end
              end
            end)
            return {}
          end
        end
      end

      -- Adapters have no agreed-on setup convention, hence the three-way dispatch below:
      -- some expose setup(), some a nested .adapter, some are callable and hand back a rebuilt
      -- adapter. Note the vim.tbl_isempty gate -- an adapter mapped to an empty table never has
      -- any of them called, so `["some-adapter"] = {}` means "defaults", not "configured".
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter = adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      -- Startup asks every registered adapter which directories and files are theirs, and the
      -- loops doing it are unguarded: root() at adapters/init.lua:13, is_test_file() at :49 and
      -- :63. An adapter that throws in either kills client startup, so *no* adapter gets
      -- registered -- neotest-vstest erroring takes Java and Angular tests down with it. Both
      -- questions already have a "no" answer that costs nothing (nil root, false is_test_file),
      -- so fall back to that and let the healthy adapters through.
      for _, adapter in ipairs(opts.adapters or {}) do
        if not claimed_wrapped[adapter] then
          claimed_wrapped[adapter] = true
          -- Listed as pairs rather than a keyed table: root's fallback is nil, and a nil value
          -- in a table constructor stores no key at all, so pairs() would never yield it.
          for _, spec in ipairs({ { "root" }, { "is_test_file", false } }) do
            local method, on_error = spec[1], spec[2]
            local original = adapter[method]
            if original then
              adapter[method] = function(...)
                local ok, result = pcall(original, ...)
                if ok then
                  return result
                end
                local name = adapter.name or "unknown adapter"
                vim.schedule(function()
                  vim.notify_once(
                    ("neotest: %s %s() failed, skipping it\n%s"):format(name, method, result),
                    vim.log.levels.WARN
                  )
                end)
                return on_error
              end
            end
          end
        end
      end

      -- neotest's status consumer keys signs and virtual text off pos.type, but only
      -- knows its own four position types. Adapters may invent their own -- neotest-vstest
      -- emits "parameterized" for xunit [Theory] / nunit [TestCase] groups -- which raises
      -- "E155: Unknown sign: neotest_parameterized" and then nil-indexes the virtual-text
      -- icon table. Relabel unknown types as namespaces, which is what they behave like.
      -- rawget, not adapter.discover_positions: the karma adapter is a lazy proxy whose __index
      -- requires neotest-karma on first touch, and doing that here -- while neotest's own opts
      -- are still being built -- reintroduces the "loop or previous error loading module" this
      -- config works around. Adapters that keep the method behind a metatable are simply left
      -- alone, which is fine, since the ones that invent position types set it directly.
      for _, adapter in ipairs(opts.adapters or {}) do
        local discover_positions = rawget(adapter, "discover_positions")
        if discover_positions and not positions_wrapped[adapter] then
          positions_wrapped[adapter] = true
          adapter.discover_positions = function(...)
            local tree = discover_positions(...)
            if tree then
              for _, node in tree:iter_nodes() do
                local pos = node:data()
                if not known_position_types[pos.type] then
                  pos.type = "namespace"
                end
              end
            end
            return tree
          end
        end
      end

      require("neotest").setup(opts)
    end,
    -- stylua: ignore
    keys = {
      {"<leader>t", "", desc = "+test"},
      { "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to Test (Neotest)" },
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
    },
  },
}
