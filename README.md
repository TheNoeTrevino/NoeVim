# NoeVim

_Get it?_

## Installation

``` bash
git clone https://github.com/TheNoeTrevino/NoeVim.git ~/.config/nvim
```

---

### Demo

Dashboard

![noevim-1](https://github.com/user-attachments/assets/dab379e5-d7bd-41bf-9cac-b8846690ead8)

Neotree

![noevim-5](https://github.com/user-attachments/assets/31f7c054-f8ba-425d-82d7-8e1e9f8c13ac)

Debugger

![noevim-4](https://github.com/user-attachments/assets/ac2eb8fa-1ddd-4f55-8deb-9d4ab9921070)

Peek Definition

![noevim-2](https://github.com/user-attachments/assets/fefd71b4-7305-4902-ad58-06a31cbb0441)

Arch config. [See that here](https://github.com/TheNoeTrevino/dotfiles)

![rice-photo](https://github.com/user-attachments/assets/ea75ed84-e339-4d62-bb52-07e5b93377a5)

### LSP NOTES

If you want to set a specific working directory for you lsps, you can do
something like this: 

``` lua
local lspconfig = require('lspconfig')

lspconfig.angularls.setup({
  root_dir = function(fname)
    return vim.fn.getcwd() .. '/frontend'
  end,
})
```

``` lua
vim.o.exrc = true
vim.o.secure = true  
```
