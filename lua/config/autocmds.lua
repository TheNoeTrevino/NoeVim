-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local map = LazyVim.safe_keymap_set

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
    vim.keymap.set("v", "<CR>", "<Plug>(DBUI_ExecuteQuery)", { buffer = true, desc = "Execute SQL" })
    vim.keymap.set(
      "v",
      "<leader>E",
      "<Plug>(DBUI_EditBindParameters)|",
      { buffer = true, desc = "Edit Parameters SQL" }
    )

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
  pattern = "go",
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

-- force o and O to show completion menu
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    -- Schedule to run after blink's own InsertEnter handler
    vim.schedule(function()
      local mode = vim.api.nvim_get_mode().mode
      if mode:match("i") then
        require("blink.cmp").show()
      end
    end)
  end,
})
