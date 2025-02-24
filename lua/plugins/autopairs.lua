return {
  "altermo/ultimate-autopair.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  -- branch = "v0.6", --recommended as each new version will have breaking changes
  opts = {
    profile = "default",
    --what profile to use
    map = true,
    --whether to allow any insert map
    cmap = true, --cmap stands for cmd-line map
    --whether to allow any cmd-line map
    pair_map = true,
    --whether to allow pair insert map
    pair_cmap = true,
    --whether to allow pair cmd-line map
    multiline = true,

    fastwarp = { -- *ultimate-autopair-map-fastwarp-config*
      enable = true,
      enable_normal = true,
      enable_reverse = true,
      hopout = false,
      --{(|)} > fastwarp > {(}|)
      map = "<c-;>", --string or table
      rmap = "<c-j>", --string or table
      cmap = "<c-;>", --string or table
      rcmap = "<c-j>", --string or table
      multiline = true,
      --(|) > fastwarp > (\n|)
      nocursormove = true,
      --makes the cursor not move (|)foo > fastwarp > (|foo)
      --disables multiline feature
      --only activates if prev char is start pair, otherwise fallback to normal
      do_nothing_if_fail = true,
      --add a module so that if fastwarp fails
      --then an `e` will not be inserted
      no_filter_nodes = { "string", "raw_string", "string_literals", "character_literal" },
      --which nodes to skip for tsnode filtering
      faster = false,
      --only enables jump over pair, goto end/next line
      --useful for the situation of:
      --{|}M.foo('bar') > {M.foo('bar')|}
      conf = {},
      --contains extension config
      multi = false,
      --use multiple configs (|ultimate-autopair-map-multi-config|)
    },

    tabout = { -- *ultimate-autopair-map-tabout-config*
      enable = true,
      map = "<tab>", --string or table
      cmap = "<tab>", --string or table
      conf = {},
      --contains extension config
      multi = false,
      --use multiple configs (|ultimate-autopair-map-multi-config|)
      hopout = false,
      -- (|) > tabout > ()|
      do_nothing_if_fail = true,
      --add a module so that if close fails
      --then a `\t` will not be inserted
    },
    --   fastwarp = {
    --     multi = true,
    --     {},
    --     { faster = true, map = "<C-;>", rmap = "<C-j>", cmap = "<C-;>", crmap = "<C-j>" },
    --   },
  },
}
