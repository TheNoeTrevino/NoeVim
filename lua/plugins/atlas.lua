return {
  -- "emrearmagan/atlas.nvim",

  dir = "~/projects/atlas.nvim/",
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
      desc = "Atlas Issues",
    },
    {
      "<leader>Ap",
      function()
        vim.cmd("AtlasPulls")
      end,
      desc = "Atlas Pulls",
    },
  },
  ---@type AtlasConfig
  opts = {
    keymaps = {
      -- jkl; layout: k = down, l = up
      ui = {
        next_item = "k",
        previous_item = "l",
      },
      pulls = {
        diff = {
          lsp = {
            enabled = true,
          },
        },
        -- `;` is "right" in jkl;, replacing the default `l` alias (which would
        -- otherwise shadow previous_item)
        review = { open_file = { ";", "<CR>" } },
      },
    },
    pulls = {

      repo_config = {
        -- what the review feature uses as a workspace for diffs
        paths = {
          ["ssglimited/icris"] = "~/projects/icris/icris.git",
          ["ssglimited/nmcris"] = "~/projects/nmcris/nmcris.git",
        },
      },
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
}
