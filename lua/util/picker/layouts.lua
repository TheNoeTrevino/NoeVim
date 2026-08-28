-- Snacks picker window layouts. Split out of plugins/editor/picker.lua, which was
-- 922 lines. These only build config tables; they open nothing and require nothing.
-- Every one is called per-keypress, so they stay functions rather than constants.

local get_config = function()
  return {
    layout = {
      cycle = true,
      --- Use the default layout or vertical if the window is too narrow
      reverse = true,
      layout = {
        box = "horizontal",
        backdrop = true,
        -- width = 0,
        -- height = 0,
        border = "none",
        {
          box = "vertical",
          { win = "list", title = " Results ", title_pos = "center", border = true },
          {
            win = "input",
            height = 1,
            border = true,
            title = "{title} {live} {flags}",
            title_pos = "center",
          },
        },
        {
          win = "preview",
          title = "{preview:Preview}",
          width = 0.6,
          border = true,
          title_pos = "center",
        },
      },
      --   function()
      --   return vim.o.columns >= 120 and "default" or "vertical"
      -- end,
    },
  }
end

local config_get_symbols = function()
  -- Custom layout instead of `preset = "vscode"`: snacks discards a preset
  -- entirely whenever the custom layout has children (see picker/config/init.lua
  -- ~L224), so tweaking a preset in place never took. Input + list stacked on
  -- the left, preview panel on the right. Every window gets a real border.
  return {
    layout = {
      layout = {
        backdrop = false,
        width = 0.6,
        min_width = 80,
        height = 0.8,
        border = "none",
        box = "vertical",
        { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
        { win = "list", border = "single" },
        { win = "preview", title = "{preview}", border = "single" },
      },
    },
  }
end

local get_spelling = function()
  return {
    layout = {
      preview = false,
      reverse = false,
      layout = {
        backdrop = true,
        row = 1,
        width = 0.4,
        min_width = 80,
        height = 0.4,
        border = "none",
        box = "vertical",
        { win = "input", height = 1, border = "single", title = "{title} {live} {flags}", title_pos = "center" },
        { win = "list", border = "single" },
        { win = "preview", title = "{preview}", border = "rounded" },
      },
    },
    on_show = function()
      vim.cmd.stopinsert()
    end,
  }
end

local get_jumplist_config = function()
  return {
    on_show = function()
      vim.cmd.stopinsert()
    end,
    layout = {
      preview = true,
      layout = {
        box = "vertical",
        backdrop = true,
        row = -1,
        width = 0,
        height = 0.33,
        border = "top",
        title = " {title} {live} {flags}",
        title_pos = "left",
        { win = "input", height = 1, border = "bottom" },
        {
          box = "horizontal",
          { win = "list", border = "none" },
          { win = "preview", title = "{preview}", width = 0.7, border = "left" },
        },
      },
    },
  }
end

local get_config_colorschemes = function()
  return {
    finder = "vim_colorschemes",
    format = "text",
    preview = "colorscheme",
    preset = "vertical",
    confirm = function(picker, item)
      picker:close()
      if item then
        picker.preview.state.colorscheme = nil
        vim.schedule(function()
          vim.cmd("colorscheme " .. item.text)
        end)
      end
    end,
  }
end

local get_config_nm = function()
  return {
    on_show = function()
      vim.cmd.stopinsert()
    end,
    layout = {
      cycle = true,
      --- Use the default layout or vertical if the window is too narrow
      reverse = true,
      layout = {
        box = "horizontal",
        backdrop = true,
        width = 0,
        height = 0,
        border = "none",
        {
          box = "vertical",
          { win = "list", title = " Results ", title_pos = "center", border = true },
          {
            win = "input",
            height = 1,
            border = true,
            title = "{title} {live} {flags}",
            title_pos = "center",
          },
        },
        {
          win = "preview",
          title = "{preview:Preview}",
          width = 0.6,
          border = true,
          title_pos = "center",
        },
      },
      --   function()
      --   return vim.o.columns >= 120 and "default" or "vertical"
      -- end,
    },
  }
end

local get_config_vert = function()
  return {
    layout = {
      cycle = true,
      --- Use the default layout or vertical if the window is too narrow
      preset = function()
        return vim.o.columns >= 120 and "default" or "vertical"
      end,
    },
  }
end


return {
  get_config = get_config,
  config_get_symbols = config_get_symbols,
  get_spelling = get_spelling,
  get_jumplist_config = get_jumplist_config,
  get_config_colorschemes = get_config_colorschemes,
  get_config_nm = get_config_nm,
  get_config_vert = get_config_vert,
}
