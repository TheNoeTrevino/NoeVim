-- Upstream is "emrearmagan/atlas.nvim"; the fork below is what ~/projects tracks.
-- Add `branch = "feature-57/lsp-attached-pull-requests"` below to pin the remote fallback.
return Util.local_plugin("TheNoeTrevino/atlas.nvim", "~/projects/atlas.nvim", {
  dependencies = {
    "MeanderingProgrammer/render-markdown.nvim", -- optional but recommended
    "esmuellert/codediff.nvim", -- optional (PullRequest diff)
  },
  lazy = false,
  keys = {
    {
      "<leader>Ai",
      function()
        vim.cmd("Atlas issues")
      end,
      desc = "Atlas Issues",
    },
    {
      "<leader>Ap",
      function()
        vim.cmd("Atlas pulls")
      end,
      desc = "Atlas Pulls",
    },
  },
  ---@type AtlasConfig
  opts = {
    keymaps = {
      ui = {
        first_item = "gg",
        last_item = "G",
        submit = "<C-s>",
        help = "g?", -- { "g?", "<leader>?" } would add aliases
        close = "q", -- false would disable it
        toggle_panel = "p",
        toggle_fold = "za",
        toggle_all_folds = "zA",
        previous_panel_tab = "<S-Tab>",
        next_panel_tab = "<Tab>",
        open_notifications = "N",
        notifications_mark_read = "r",
        notifications_mark_done = "d",
        notifications_refresh = "R",
        toggle_subscription = "gS",
        refresh = "r",
        refresh_view = "R",
        open_actions = "A",
        open_in_browser = "gx",
        copy_id = "y",
        copy_url = "Y",
        show_details = "gk",
        search = "?",
      },
      issues = {
        transition_issue = "gs",
        change_assignee = "ga",
        change_reporter = "gr",
        edit_issue = "ge",
        create_issue = "c",
      },
      pulls = {
        open_diff = "gd",
        checkout = "gc",
        edit_title = "T",
        edit_description = "D",
        review = {
          open_file = { "l", "<CR>" },
          toggle_approval = "Ga",
          request_changes = "Gr",
          submit_review = "Gs",
          explorer = {
            focus_file = "<CR>",
            open_file = "l",
            next_file = { "]f", "<Tab>" },
            previous_file = { "[f", "<S-Tab>" },
            next_unreviewed_file = "]u",
            previous_unreviewed_file = "[u",
            toggle_grouping = "T",
            toggle_file_reviewed = "-",
            toggle_commits = "GC",
          },
          diff = {
            toggle_layout = "t",
            toggle_compact = "u",
            next_hunk = "]h",
            previous_hunk = "[h",
            toggle_review_panel = "gR",
            toggle_comments = "gH",
            next_comment = "]c",
            previous_comment = "[c",
            next_note = "]n",
            previous_note = "[n",
            add_comment = "c",
            submit_comment = "C",
            edit_comment = "e",
            delete = "dd",
            add_note = "<leader>n",
            add_task = "T",
            toggle_resolved = "x",
          },
        },
        filters = {
          open = "gpo",
          merged = "gpm",
          declined = "gpd",
        },
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
})
