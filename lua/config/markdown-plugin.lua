local function capitalize_sentences()
  local line = vim.api.nvim_get_current_line()
  line = line:gsub("%.%s*%l", function(match)
    return match:upper()
  end)
  line = line:gsub("^%l", string.upper)
  vim.api.nvim_set_current_line(line)
end

vim.api.nvim_create_autocmd("TextChangedI", {
  pattern = "*.md",
  callback = capitalize_sentences,
  desc = "Auto-capitalize senteces in markdown files",
})
