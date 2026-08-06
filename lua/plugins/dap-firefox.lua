-- Firefox frontend debugging (the VSCode "debug the TS running in the browser" feature).
--
-- Topology here is unusual and drives every choice below: Neovim and the debug
-- adapter run inside WSL, Firefox runs on Windows. That only works because
-- .wslconfig sets networkingMode=mirrored, which puts WSL and Windows on one
-- localhost -- the adapter dials localhost:6000 and lands on Firefox's remote
-- debugging server across the boundary. Under the default NAT mode this would
-- need the host IP plus a firewall rule instead.
--
-- Consequence of Firefox being Windows-side: only "attach" is offered. Launch
-- mode has the adapter spawn Firefox with a generated profile directory, and it
-- would hand a WSL path (/tmp/...) to a Windows exe that cannot read it. Launch
-- would require a WSL-native Firefox via WSLg.
--
-- ONE-TIME Firefox setup, in about:config:
--   devtools.debugger.remote-enabled    = true
--   devtools.chrome.enabled             = true
--   devtools.debugger.prompt-connection = false
-- If connecting is refused, also set devtools.debugger.force-local = false.
-- Mirrored-mode traffic usually arrives as loopback, so try without it first.
--
-- Then start the browser with :FirefoxDebug (below) and <leader>dc -> "Attach".
--
-- SECURITY: while the debugger server is listening, anything that can reach
-- localhost:6000 has full control of that browser -- reading cookies, sessions,
-- and any logged-in tab. Only run it while actually debugging.

local FIREFOX_EXE = "/mnt/c/Users/noe.trevino/AppData/Local/Mozilla Firefox/firefox.exe"
local RDP_PORT = 6000

return {
  {
    "mason-org/mason.nvim",
    -- mason.lua sets opts_extend = { "ensure_installed" }, so this list is
    -- appended rather than replacing the one defined there.
    opts = { ensure_installed = { "firefox-debug-adapter" } },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      handlers = {
        -- Suppress mason-nvim-dap's stock firefox setup. Its only config is a
        -- *launch* one with firefoxExecutable = vim.fn.exepath("firefox"),
        -- which is "" here -- Firefox is a Windows install, not on WSL's PATH.
        -- It would sit in the picker looking valid and fail on selection.
        --
        -- Keyed per-adapter, so every other installed source still gets
        -- default_setup -- notably js-debug-adapter, which is where the
        -- pwa-chrome adapter behind test-karma.lua's config comes from.
        firefox = function() end,
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    event = "VeryLazy",
    opts = function()
      local dap = require("dap")

      -- Mirrors install_root_dir in mason.lua. Not $MASON: that env var is only
      -- exported on win32 there (for roslyn), so it is unset on Linux. Not
      -- exepath() either, since mason.nvim is cmd-lazy and may not have put its
      -- bin dir on PATH by the time this runs.
      local mason_bin = vim.fn.has("win32") == 1 and "C:/mason/bin/" or (vim.fn.stdpath("data") .. "/mason/bin/")

      dap.adapters.firefox = {
        type = "executable",
        command = mason_bin .. "firefox-debug-adapter",
        args = {},
      }

      -- The web root is the directory the bundler treats as "." -- for Angular
      -- that is the directory holding angular.json, NOT the git root. Getting
      -- this wrong is silent: the session attaches, sources load, and every
      -- breakpoint just stays unverified (red, via DapBreakpointRejected)
      -- because the mapped path points at a file that does not exist.
      --
      -- Deliberately NOT vim.fn.getcwd()/${workspaceFolder}: this repo is a
      -- monorepo whose git root holds frontend/ and backend/, so nvim opened at
      -- the repo root yields a root one level above angular.json.
      --
      -- Resolved from the current buffer at session start rather than at plugin
      -- load, since nvim-dap's eval_option runs function-valued config fields
      -- when the session launches -- by which point the buffer is the file
      -- being debugged.
      local last_root
      local function web_root()
        local buf = vim.api.nvim_buf_get_name(0)
        local from = buf ~= "" and vim.fs.dirname(buf) or vim.fn.getcwd()

        local root
        -- angular.json first: in a monorepo, package.json often also sits at the
        -- git root, which is exactly the wrong answer.
        for _, marker in ipairs({ "angular.json", "package.json" }) do
          local hit = vim.fs.find(marker, { path = from, upward = true })[1]
          if hit then
            root = vim.fs.dirname(hit)
            break
          end
        end
        root = root or vim.fn.getcwd()

        -- Surface the resolved root once per distinct value. A wrong root is
        -- otherwise invisible until breakpoints silently fail to bind.
        if root ~= last_root then
          last_root = root
          vim.notify("Firefox debug web root:\n" .. root, vim.log.levels.INFO, { title = "DAP" })
        end
        return root
      end

      -- Source maps are the whole game. Angular 18's @angular-devkit/build-angular:application
      -- builder (esbuild/vite) emits inline base64 maps whose `sources` are
      -- project-root-relative ("src/app/x.ts") with no sourceRoot, so they
      -- resolve against the dev-server origin: http://localhost:4200/src/app/x.ts.
      -- The webpack:/// entries cover the older builder and are inert otherwise.
      local function path_mappings(origin)
        return function()
          local root = web_root()
          return {
            { url = origin .. "/src", path = root .. "/src" },
            { url = origin .. "/@fs" .. root, path = root },
            { url = "webpack:///./src", path = root .. "/src" },
            { url = "webpack:///src", path = root .. "/src" },
            { url = "webpack:///./", path = root .. "/" },
            -- Catch-all: a prefix of the entries above, so it must stay last.
            { url = origin, path = root },
          }
        end
      end

      local function attach_config(name, origin)
        return {
          name = name,
          type = "firefox",
          request = "attach",
          host = "localhost",
          port = RDP_PORT,
          -- Becomes the tab filter /^<url>.*/ , so an origin matches every route
          -- under it -- /projects/123?x=y included.
          url = origin,
          webRoot = web_root,
          pathMappings = path_mappings(origin),
          sourceMaps = true,
          -- Verification is asynchronous: setBreakpoints returns verified=false
          -- and a `breakpoint` event flips it ~2s later. Red briefly after
          -- attaching is normal; red that never clears means a bad web root.
          --
          -- Uncomment to diagnose -- the log prints a "PathConversion: Converted
          -- url X to path Y" line for every source, which shows immediately
          -- whether Y is a real file. Note it can reach tens of MB.
          -- log = {
          --   fileName = "/tmp/firefox-adapter.log",
          --   fileLevel = { default = "Debug" },
          -- },
        }
      end

      -- `url` and `pathMappings` both need the same origin, and both are
      -- evaluated during one synchronous expansion pass -- so prompt on the
      -- first of them and reuse the answer for the second. The vim.schedule
      -- clear runs on the next tick, i.e. after that pass has finished, so the
      -- next session prompts again.
      local pending_origin
      local function prompt_origin()
        if not pending_origin then
          pending_origin = vim.fn.input("Dev server origin: ", "http://localhost:")
          vim.schedule(function()
            pending_origin = nil
          end)
        end
        return pending_origin
      end

      local configs = {
        attach_config("Attach to Firefox (Angular :4200)", "http://localhost:4200"),
        attach_config("Attach to Firefox (:3000)", "http://localhost:3000"),
        {
          name = "Attach to Firefox (prompt for origin)",
          type = "firefox",
          request = "attach",
          host = "localhost",
          port = RDP_PORT,
          url = prompt_origin,
          webRoot = web_root,
          pathMappings = function()
            return path_mappings(prompt_origin())()
          end,
          sourceMaps = true,
        },
      }

      for _, ft in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[ft] = dap.configurations[ft] or {}
        vim.list_extend(dap.configurations[ft], configs)
      end
    end,

    init = function()
      vim.api.nvim_create_user_command("FirefoxDebug", function(cmd)
        if vim.fn.filereadable(FIREFOX_EXE) == 0 then
          vim.notify("Firefox not found at:\n" .. FIREFOX_EXE, vim.log.levels.ERROR, { title = "FirefoxDebug" })
          return
        end

        local args = { FIREFOX_EXE, "--start-debugger-server", tostring(RDP_PORT) }
        if cmd.args ~= "" then
          table.insert(args, cmd.args)
        end

        vim.fn.jobstart(args, { detach = true })
        vim.notify(
          ("Firefox starting with debugger server on :%d.\nAttach with <leader>dc."):format(RDP_PORT),
          vim.log.levels.INFO,
          { title = "FirefoxDebug" }
        )
      end, {
        nargs = "?",
        desc = "Launch Windows Firefox with remote debugging enabled",
      })
    end,
  },
}
