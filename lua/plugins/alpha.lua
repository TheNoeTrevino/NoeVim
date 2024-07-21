return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                                          ]],
      [[                                                                          ]],
      [[                                                                          ]],
      [[                                                                          ]],
      [[                                    ███                               ]],
      [[       ████ ██████              █████    █  ██                   ]],
      [[      ███████████               █████  ███                        ]],
      [[      █████████ ██████ ████████████████ ██ ██████████    ]],
      [[     █████████ ██  ██ ██    ██████████ ████ ██████████████    ]],
      [[    █████████ ███    ███ █████ ████████  ████ ████████████    ]],
      [[  ███████████ ███  ███  ██    ██████   ████ ████ ████ ████    ]],
      [[ ██████  ███   ████████    █████ ████    ████ ████ ████ ████   ]],
      [[                                                                          ]],
      [[                                                                          ]],
      [[                                                                          ]],
    }

    dashboard.section.header.opts = {
      position = "center",
    }

    -- Custom buttons
    dashboard.section.buttons.val = {
      dashboard.button("r", "  Reload Last Session", ":SessionRestore<CR>"),
      dashboard.button("f", "󰥨  Find file", ":Telescope find_files<CR>"),
      dashboard.button("g", "󰩉  Live grep", ":Telescope live_grep<CR>"),
      dashboard.button("h", "󰋖  Help tags", ":Telescope help_tags<CR>"),
      dashboard.button("c", "  Check health", ":checkhealth<CR>"),
      dashboard.button("k", "  Key mappings", ":Telescope keymaps<CR>"),
      dashboard.button("o", "  Open config", ":e $MYVIMRC<CR>"),
      dashboard.button("t", "  Open terminal", ":split | terminal<CR>"),
      dashboard.button("q", "󰩈  Quit Neovim", ":qa<CR>"),
    }

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
          vim.cmd("cd " .. vim.fn.argv(0))
          vim.cmd("enew")
          vim.cmd("bwipeout 1")
          alpha.start()
        end
      end,
    })
  end,
}
