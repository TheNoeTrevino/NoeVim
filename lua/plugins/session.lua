return {
  "rmagatti/auto-session",
  config = function ()
    require("auto-session").setup({
      log_level = 'info',
      auto_restore_enabled = false,
    })
  end
}
