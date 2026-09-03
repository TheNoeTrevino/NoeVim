-- Seamless <C-hjkl> movement across Neovim splits AND herdr panes.
--
-- This REPLACES the plain <C-w>hjkl window maps that used to live in
-- config/defaults/keymaps.lua. The plugin moves the Neovim window first; when
-- the cursor is already at the edge, it hands the move to herdr instead.
--
-- The herdr half is a separate plugin (willfish/herdr-navigator), installed
-- with `herdr plugin install willfish/herdr-navigator`, and bound to
-- ctrl+h/j/k/l in ~/.config/herdr/config.toml as `plugin_action` entries.
-- Both halves must agree on the chord or the edge hand-off does nothing.
--
-- Ctrl, not the plugin's default Alt: the herdr server log flags alt chords
-- ("flushing lone escape after input timeout"), which is why focus_agent is
-- still commented out in config.toml.
return {
  "willfish/herdr-navigator.nvim",
  event = "VeryLazy",
  opts = {
    -- Single source of truth for the chords. Both branches below read this.
    mappings = {
      left = "<C-h>",
      down = "<C-j>",
      up = "<C-k>",
      right = "<C-l>",
    },
  },
  -- setup() is called explicitly. Relying on lazy's opts -> main.setup(opts)
  -- shortcut silently produced the plugin's default <M-hjkl> maps instead.
  config = function(_, opts)
    local nav = require("herdr-navigator")

    -- is_herdr() checks HERDR_SESSION / HERDR_PANE_ID / HERDR_ENV. Outside a
    -- herdr pane the plugin's setup() returns before it maps anything, so
    -- these chords would be left unmapped -- there is no <C-w>hjkl underneath
    -- them any more. Map plain window movement instead.
    if nav.is_herdr() then
      nav.setup(opts)
      return
    end

    local wincmd = { left = "h", down = "j", up = "k", right = "l" }
    local desc = { left = "Left", down = "Lower", up = "Upper", right = "Right" }
    for name, lhs in pairs(opts.mappings) do
      if wincmd[name] and lhs and lhs ~= "" then
        vim.keymap.set("n", lhs, "<C-w>" .. wincmd[name], {
          desc = "Go to " .. desc[name] .. " Window",
          remap = true,
        })
      end
    end
  end,
}
