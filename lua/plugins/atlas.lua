return {
  "emrearmagan/atlas.nvim",
  dependencies = {
    "MeanderingProgrammer/render-markdown.nvim", -- optional but recommended
    "esmuellert/codediff.nvim", -- optional (PullRequest diff)
  },
  lazy = false,
  keys = {
    {
      "<leader>Ai",
      function()
        vim.cmd("AtlasIssues")
      end,
      desc = "Seek Files",
    },
    {
      "<leader>Ap",
      function()
        vim.cmd("AtlasPulls")
      end,
      desc = "Seek Files",
    },
  },
  opts = {
    pulls = {
      providers = {
        bitbucket = {
          user = vim.env.BITBUCKET_USER,
          token = vim.env.BITBUCKET_TOKEN,
          cache_ttl = 300,

          ---@type AtlasBitbucketViewConfig[]
          views = {
            {
              name = "ICRIS",
              key = "I",
              layout = "compact",
              repos = {
                { workspace = "ssglimited", repo = "icris" },
              },
            },
            {
              name = "NMCRIS",
              key = "N",
              layout = "compact",
              repos = {
                { workspace = "ssglimited", repo = "nmcris" },
              },
            },
          },
        },
      },
    },
    issues = {
      max_results = 100,
      with_relationships = true, -- Fetch parent/subissue relationships for plain issue tree views.
      custom_actions = {}, --
      providers = {
        jira = {
          base_url = "https://respec-dts.jira.com",
          email = "noe.trevino@respec.com",
          --- See: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
          token = vim.env.JIRA_TOKEN,
          auth_method = "basic", -- "basic" or "bearer", defaults to "basic". If using bearer, set `token` to your API token.
          api_type = "cloud", -- either "cloud" or "server", defaults to "cloud". Cloud API is v3, server API is v2
          cache_ttl = 300,

          project_config = {
            -- The Jira custom field ID used for story points. Defaults to "customfield_10016".
            story_points_field = "customfield_10016",

            ICRIS = {
              customfield_10003 = {
                name = "Approvers",
                format = function(value)
                  if type(value) ~= "table" or #value == 0 then
                    return nil -- nil hides the field
                  end
                  return table.concat(value, ", ")
                end,
                hl_group = "AtlasChipActive",
                display = "chip", -- "chip" or "table"
              },
            },
          },

          ---@type AtlasJiraViewConfig[]
          views = {
            {
              name = "ICRIS - Mine",
              key = "I",
              layout = "compact",
              jql = "project = ICRIS AND assignee = currentUser() AND statusCategory != Done AND statusCategory != 'To Do' ORDER BY status ASC, updated DESC",
            },
            {
              name = "ICRIS - All",
              key = "i",
              layout = "compact",
              jql = "project = ICRIS AND statusCategory != Done AND statusCategory != 'To Do' ORDER BY status ASC, updated DESC",
            },
            {
              name = "NMCRIS - Mine",
              key = "N",
              layout = "compact",
              jql = "project = NMCRIS AND assignee = currentUser() AND statusCategory != Done AND statusCategory != 'To Do' ORDER BY status ASC, updated DESC",
            },
          },

          bookmarks = {
            key = "J", -- default
            label = "JQL", -- default
            items = {
              ["Backlog"] = "project = ICRIS AND statusCategory != Done AND (sprint IS EMPTY OR sprint NOT IN openSprints()) ORDER BY Rank ASC",
              ["Next sprint"] = "project = ICRIS AND sprint in futureSprints() ORDER BY Rank ASC",
              ["My open"] = "assignee = currentUser() AND statusCategory != Done ORDER BY updated DESC",
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("atlas").setup(opts)

    -- atlas hardcodes j = down / k = up for list navigation (not exposed in the
    -- keymaps config). Shift to a jkl; layout: k = down, l = up. These register()
    -- fns run on every open/refresh, so wrap them to re-apply after the plugin.
    local nav_by_module = {
      ["atlas.ui.keymaps"] = "atlas.ui.navigation",
      ["atlas.pulls.ui.panel.pr.keymaps"] = "atlas.pulls.ui.panel.pr.navigation",
      ["atlas.pulls.ui.panel.repo.keymaps"] = "atlas.pulls.ui.panel.repo.navigation",
      ["atlas.issues.ui.panel.issue.keymaps"] = "atlas.issues.ui.panel.issue.navigation",
    }

    for mod_name, nav_name in pairs(nav_by_module) do
      local mod = require(mod_name)
      local orig = mod.register
      mod.register = function(buf, ...)
        local ret = orig(buf, ...)
        if type(buf) == "number" and vim.api.nvim_buf_is_valid(buf) then
          local nav = require(nav_name)
          local mapopts = { buffer = buf, nowait = true, silent = true }
          vim.keymap.set("n", "k", function()
            nav.move_cursor("down")
          end, mapopts)
          vim.keymap.set("n", "l", function()
            nav.move_cursor("up")
          end, mapopts)
          pcall(vim.keymap.del, "n", "j", { buffer = buf })
        end
        return ret
      end
    end
  end,
}
