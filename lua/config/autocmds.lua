-- Loaded on the VeryLazy event. Load the default autocmds first, then the personal ones.
require("config.defaults.autocmds")
-- Add any additional autocmds here

-- save buffers in markdown when leaving then
vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "set awa" })

-- Make * double for markdown files. For some reason in markdown * is italic?
-- and so is _ ? weird
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    require("nvim-surround").buffer_setup({
      surrounds = {
        ["*"] = {
          add = function()
            return { { "**" }, { "**" } }
          end,
        },
      },
    })
  end,
})

vim.api.nvim_create_user_command("ToggleGutter", function()
  if vim.wo.number or vim.wo.relativenumber or vim.wo.signcolumn ~= "no" or vim.wo.foldcolumn ~= "0" then
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.foldcolumn = "0"
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.wo.signcolumn = "yes"
    vim.wo.foldcolumn = "1"
  end
end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.smartindent = true
    vim.bo.cinoptions = "j1,J1,(0,w1,W1"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.cindent = true
    vim.bo.cinoptions = "j1,J1,(0,w1,W1"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dap-repl", "dapui_watches", "dapui_hover" },
  callback = function()
    vim.b.completion = true
  end,
  desc = "Enable completion for DAP-REPL filetypes",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbui",
  callback = function()
    vim.keymap.set("n", "<C-J>", "", { buffer = true })
  end,
})

-- AUtocmd to boost certain LSP semantic token highlight priority
-- readonly is boosted so show constants
---@class SemanticTokenModifiers
---@field declaration boolean?
---@field documentation boolean?
---@field global boolean?

---@class SemanticToken
---@field line number
---@field start_col number
---@field end_col number
---@field marked boolean
---@field type string
---@field modifiers SemanticTokenModifiers

local boost = {
  -- { type = "namespace" },
  -- { type = "variable" },
  --
  -- { modifier = "global" },
  -- { modifier = "format" },
  { modifier = "readonly", priority = 110 },
  --
  -- { treesitter = "constant.builtin", priority = 106 },
  -- { treesitter = "namespace.builtin", priority = 106 },
  -- { treesitter = "boolean", priority = 107 },
}

-- update certain tokens to use a highlight of a higher priority
vim.api.nvim_create_autocmd("LspTokenUpdate", {
  pattern = { "go", "typescript" },
  callback = function(args)
    --- @type SemanticToken
    local token = args.data.token
    local captures = vim.treesitter.get_captures_at_pos(args.buf, token.line, token.start_col)

    for _, t in pairs(boost) do
      local priority = t.priority or 105
      if t.type and token.type == t.type then
        vim.lsp.semantic_tokens.highlight_token(
          token,
          args.buf,
          args.data.client_id,
          "@lsp.type." .. t.type,
          { priority = priority }
        )
      end

      if t.modifier and token.modifiers[t.modifier] then
        vim.lsp.semantic_tokens.highlight_token(
          token,
          args.buf,
          args.data.client_id,
          "@lsp.mod." .. t.modifier,
          { priority = priority }
        )
      end

      if t.treesitter then
        for _, capture in pairs(captures) do
          if capture.capture == t.treesitter then
            vim.lsp.semantic_tokens.highlight_token(
              token,
              args.buf,
              args.data.client_id,
              "@" .. t.treesitter,
              { priority = priority }
            )
          end
        end
      end
    end
  end,
})

-- In the `cast` project, ignore whitespace in gitsigns diffs.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.getcwd():match("projects[/\\]cast$") then
      local ok, gitsigns = pcall(require, "gitsigns")
      if ok then
        gitsigns.setup({ diff_opts = { ignore_whitespace = true } })
      end
    end
  end,
})

-- dbout (vim-dadbod-ui query output): render `---` separator runs as a solid rule.
do
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
end
