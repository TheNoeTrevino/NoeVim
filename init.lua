if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end

require("config.lazy")

-- Colorscheme highlight overrides now live declaratively in the kanagawa spec
-- (lua/plugins/ui.lua, `overrides = function() ... end`). Keeping them there means
-- they are reapplied whenever the colorscheme loads, instead of being set once here.

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.cmd("packadd nvim.undotree")

local ns = vim.api.nvim_create_namespace("dbout_rule")
local function redraw(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if line:match("^[%-%s]+$") and line:find("%-%-%-") then -- separator line only
      for s, e in line:gmatch("()%-+()") do
        vim.api.nvim_buf_set_extmark(buf, ns, i - 1, s - 1, {
          virt_text = { { ("─"):rep(e - s), "Comment" } },
          virt_text_pos = "overlay",
        })
      end
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbout",
  callback = function(ev)
    redraw(ev.buf)
    vim.api.nvim_create_autocmd({ "TextChanged", "BufWinEnter" }, {
      buffer = ev.buf,
      callback = function()
        redraw(ev.buf)
      end,
    })
  end,
})
