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
      -- `;` is "right" in jkl;, replacing the default `l` alias (which would
      -- otherwise shadow previous_item)
      pulls = {
        review = { open_file = { ";", "<CR>" } },
      },
    },
    pulls = {
      diff = {
        lsp = {
          enabled = true,
        },
      },

      repo_config = {
        -- what the review feature uses as a workspace for diffs
        paths = {
          ["ssglimited/icris"] = "~/projects/icris/icris.git",
          ["ssglimited/nmcris"] = "~/projects/nmcris/nmcris.git",
        },
      },
      providers = {
        ---@type AtlasGitHubConfig
        github = {
          -- auth comes from the `gh` CLI (`gh auth login`) -- no user/token here
          cache_ttl = 300,

          ---@type AtlasGitHubViewConfig[]
          views = {
            { name = "My Open", key = "m", layout = "compact", search = "is:open is:pr author:@me" },
            { name = "Assigned", key = "g", layout = "compact", search = "is:pr assignee:@me archived:false" },
            { name = "Reviewing", key = "G", layout = "compact", search = "is:pr review-requested:@me archived:false" },
          },

          bookmarks = {
            key = "S", -- default
            label = "Search", -- default
            items = {
              ["Drafts"] = "is:pr is:draft author:@me",
              ["Recently merged"] = "is:pr is:merged author:@me sort:updated-desc",
            },
          },
        },
        ---@type AtlasBitbucketConfig
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
        github = {
          cache_ttl = 300,
          ---@type AtlasGitHubIssuesViewConfig[]
          views = {
            {
              name = "Assigned",
              key = "1",
              layout = "plain",
              search = "assignee:@me is:open",
            },
            {
              name = "Created",
              key = "2",
              layout = "compact",
              search = "author:@me is:open",
            },
            {
              name = "Mentions",
              key = "3",
              layout = "plain",
              search = "mentions:@me is:open",
            },
          },

          bookmarks = {
            key = "S", -- default
            label = "Search", -- default
            items = {
              ["Bugs"] = "is:issue is:open label:bug",
              ["Recently closed"] = "is:issue is:closed author:@me sort:updated-desc",
            },
          },
        },
      },
    },
  },
}
