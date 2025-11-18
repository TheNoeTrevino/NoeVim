return {
  { "TheNoeTrevino/roids.nvim" },
  {
    dir = "~/projects/no-go.nvim",
    opts = {
      -- Enable the plugin behavior by default
      enabled = true,

      -- Identifiers to match in if statements (e.g., "if err != nil", "if error != nil")
      -- Only collapse blocks where the identifier is in this list
      identifiers = { "err" },

      -- Virtual text for collapsed error handling
      -- Built as: prefix + content + content_separator + return_character + suffix
      -- The default follows Jetbrains GoLand style of concealment:
      virtual_text = {
        prefix = ": ",
        content_separator = " ",
        return_character = "󱞿 ",
        suffix = "",
      },

      -- Highlight group for the collapsed text
      highlight_group = "NoGoZone",

      -- Default highlight colors
      highlight = {
        bg = "#2A2A37",
        -- fg = "#808080", -- Optional foreground color
      },

      -- Auto-update on these events
      update_events = {
        "BufEnter",
        "BufWritePost",
        "TextChanged",
        "TextChangedI",
        "InsertLeave",
      },

      -- Key mappings to skip over concealed lines
      -- The plugin automatically remaps these keys to skip concealed error blocks
      -- If you want to set them to something else, you will have to set them here. Or false to disable
      keymaps = {
        move_down = "k", -- Key to move down and skip concealed lines
        move_up = "l", -- Key to move up and skip concealed lines
      },

      -- Reveal concealed lines when cursor is on the if err != nil line
      -- This allows you to inspect the error handling by hovering over the collapsed line
      reveal_on_cursor = true,
    },
  },
  -- everywhere else
  -- { dir = "~/roids.nvim/" },
  -- { dir = "~/projects/roids.nvim/" },
  -- Macbook
}
