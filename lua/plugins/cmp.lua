---@diagnostic disable: missing-fields
return {
  {
    "hrsh7th/cmp-cmdline",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/cmp-dap",
    },
    config = function()
      local cmp = require("cmp")

      local noevim_mappings = {
        -- Confirm
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = false })
          else
            fallback()
          end
        end, { "i", "c" }),
      }

      local next_mappings = { "<Down>", "<C-K>", "<C-N>" }
      for _, m in ipairs(next_mappings) do
        noevim_mappings[m] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "c" })
      end

      local previous_mappings = { "<Up>", "<C-L>", "<C-P>" }
      for _, m in ipairs(previous_mappings) do
        noevim_mappings[m] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "c" })
      end

      -- Setup for dap completion
      cmp.setup({
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        mapping = noevim_mappings,
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })

      -- Setup for `/`, `?` command-line
      cmp.setup.cmdline({ "/", "?" }, {
        sources = {
          { name = "buffer" },
        },
      })

      -- Setup for `:` command-line
      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = { "jakewvincent/mkdnflow.nvim" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "mkdnflow" })
      opts.experimental = {
        ghost_text = false, -- Disable ghost text here
      }

      local cmp_window = require("cmp.config.window")
      opts.window = {
        completion = cmp_window.bordered(),
        documentation = cmp_window.bordered(),
      }
    end,
  },
}
