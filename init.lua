if vim.env.PROF then
  -- Profile startup with snacks.profiler: `PROF=1 nvim`.
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
    },
  })
end

require("config.lazy")

-- Load the vendored undotree pack (opt). Kept here (after lazy) to match its
-- previous load timing.
vim.cmd("packadd nvim.undotree")
