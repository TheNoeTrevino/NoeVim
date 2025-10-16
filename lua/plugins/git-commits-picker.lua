return {
  "ibhagwan/fzf-lua",
  opts = {

    -- NOTE:
    -- - Added `--tac` option to reverse the order of the input.
    --
    --
    --     - One might argue that this option is unnecessary since we can already put
    --
    --
    --       `tac` or `tail -r` in the command pipeline to achieve the same result.
    --
    --
    --       However, the advantage of `--tac` is that it does not block until the
    --
    --
    --       input is complete.
    winopts = {
      -- split = "belowright new",-- open in a split instead?
      -- "belowright new"  : split below
      -- "aboveleft new"   : split above
      -- "belowright vnew" : split right
      -- "aboveleft vnew   : split left
      -- Only valid when using a float window
      -- (i.e. when 'split' is not defined, default)
      height = 0.9, -- window height
      width = 0.9, -- window width
      row = 0.35, -- window row position (0=top, 1=bottom)
      col = 0.50, -- window col position (0=left, 1=right)
      -- border argument passthrough to nvim_open_win()
      border = "single",
      -- Backdrop opacity, 0 is fully opaque, 100 is fully transparent (i.e. disabled)
      backdrop = 60,
      -- title         = "Title",
      -- title_pos     = "center",        -- 'left', 'center' or 'right'
      -- title_flags   = false,           -- uncomment to disable title flags
      fullscreen = false, -- start fullscreen?
      -- flip_lines = false,
      -- enable treesitter highlighting for the main fzf window will only have
      -- effect where grep like results are present, i.e. "file:line:col:text"
      -- due to highlight color collisions will also override `fzf_colors`
      -- set `fzf_colors=false` or `fzf_colors.hl=...` to override
      treesitter = {
        enabled = true,
        fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" },
      },
      preview = {
        -- default     = 'bat',           -- override the default previewer?
        -- default uses the 'builtin' previewer
        border = "single", -- preview border: accepts both `nvim_open_win`
        -- and fzf values (e.g. "border-top", "none")
        -- native fzf previewers (bat/cat/git/etc)
        -- can also be set to `fun(winopts, metadata)`
        wrap = false, -- preview line wrap (fzf's 'wrap|nowrap')
        hidden = false, -- start preview hidden
        vertical = "down:45%", -- up|down:size
        horizontal = "right:60%", -- right|left:size
        layout = "vertical",
        flip_columns = 100, -- #cols to switch to horizontal on flex
        -- Only used with the builtin previewer:
        title = true, -- preview border title (file/buf)?
        title_pos = "center", -- left|center|right, title alignment
        scrollbar = "float", -- `false` or string:'float|border'
        -- float:  in-window floating border
        -- border: in-border "block" marker
        scrolloff = -1, -- float scrollbar offset from right
        -- applies only when scrollbar = 'float'
        delay = 20, -- delay(ms) displaying the preview
        -- prevents lag on fast scrolling
        winopts = { -- builtin previewer window options
          number = true,
          relativenumber = false,
          cursorline = true,
          cursorlineopt = "both",
          cursorcolumn = false,
          signcolumn = "no",
          list = false,
          foldenable = false,
          foldmethod = "manual",
        },
      },
      on_create = function()
        -- called once upon creation of the fzf main window
        -- can be used to add custom fzf-lua mappings, e.g:
        --   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
      end,
      -- called once _after_ the fzf interface is closed
      -- on_close = function() ... end
    },
  },

  keys = {
    {
      "<leader>gc",
      function()
        local fzf = require("fzf-lua")

        -- Git log command with nice formatting
        local git_cmd =
          "git log --color=always --pretty=format:'%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)(%ar)%Creset %s %C(bold blue)- %an%Creset' --date=short"

        -- First hash storage
        local hash_1 = nil

        local function pick_commit(prompt_text, header_text, cmd)
          fzf.fzf_exec(cmd or git_cmd, {
            prompt = prompt_text,
            header = header_text,
            preview = "git show --color=always {1} | delta ",
            actions = {
              ["default"] = function(selected)
                if selected and #selected > 0 then
                  -- Extract commit hash (first field)
                  local hash = selected[1]:match("^%s*(%S+)")
                  if hash then
                    if not hash_1 then
                      -- First selection
                      hash_1 = hash
                      vim.notify("First commit selected (FROM/BEFORE): " .. hash_1)
                      -- Pick second commit - only show commits after hash_1
                      vim.schedule(function()
                        local filtered_cmd = "git log --color=always --pretty=format:'%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)(%ar)%Creset %s %C(bold blue)- %an%Creset' --date=short "
                          .. hash_1
                          .. "..HEAD"
                        pick_commit(
                          "Select Second Commit (TO/AFTER)> ",
                          "Showing diff FROM first commit TO this commit",
                          filtered_cmd
                        )
                      end)
                    else
                      -- Second selection
                      local hash_2 = hash
                      vim.notify("hash one: " .. hash_1 .. " hash two: " .. hash_2)
                      -- Open diff in DiffviewOpen
                      vim.cmd("DiffviewOpen " .. hash_1 .. ".." .. hash_2)
                      -- Reset for next use
                      hash_1 = nil
                    end
                  end
                end
              end,
              -- TODO: add mappings
              ["ctrl-y"] = function(selected)
                if selected and #selected > 0 then
                  -- Extract and copy commit hash
                  local hash = selected[1]:match("^%s*(%S+)")
                  if hash then
                    vim.fn.setreg("+", hash)
                    vim.notify("Copied commit hash: " .. hash)
                  end
                end
              end,
            },
            fn_transform = function(x)
              return x
            end,
          })
        end

        -- Start the picking process
        pick_commit("Select First Commit (FROM/BEFORE)> ", "Select the older commit to compare FROM")
      end,
      desc = "Git Commits (FZF)",
    },
  },
}
