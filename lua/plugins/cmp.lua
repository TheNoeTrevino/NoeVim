---@diagnostic disable: missing-fields
return {
  {
    "hrsh7th/cmp-cmdline",
    event = "VeryLazy",
    config = function()
      local cmp = require("cmp")

      -- Setup for `/` command-line
      cmp.setup.cmdline("/", {
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end, { "i", "c" }),
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "c" }),

          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "c" }),
        },
        sources = {
          { name = "buffer" },
        },
      })
      -- Setup for `:` command-line
      cmp.setup.cmdline(":", {
        -- Make mappings the same as the other completion mappings
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end, { "i", "c" }),
          ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "c" }),

          ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "c" }),
        },
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
  -- Extend nvim-cmp configuration with mkdnflow.nvim
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "jakewvincent/mkdnflow.nvim" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- Add mkdnflow completion source
      table.insert(opts.sources, { name = "mkdnflow" })

      local cmp_kinds = {
        Text = " ",
        Method = " ",
        Function = "󰊕 ",
        Constructor = "󰀊 ",
        Field = "󰓹 ",
        Variable = "󰀫 ",
        Class = " ",
        Interface = " ",
        Module = "󱒌 ",
        Property = " ",
        Unit = " ",
        Value = " ",
        Enum = " ",
        Keyword = " ",
        Snippet = "󰩫 ",
        Color = " ",
        File = " ",
        Reference = " ",
        Folder = " ",
        EnumMember = " ",
        Constant = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
      } -- If you want to configure icons, you can add this inside opts.formatting

      opts.formatting = {
        fields = { "abbr", "kind" },
        format = function(_, vim_item)
          vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
          return vim_item
        end,
      }
    end,
  },
}
