# NoeVim

_Get it?_

---

##### This is a fork of LazyVim, so why use this instead?

## Extremely Fast!!

NoeVim loads in about 55 miliseconds on average! It only loads the essentials like Telescope, Treesitter, and the colorscheme on load.
Everything is loaded direcly afterwards. This gives the illusion that nvim is loaded instantly!

## The Vim Way

This distro encourages the use of native vim features when editing text.

No buffer lines of any sort.

This setup encourages the use of the _native tabs_. Set a window layout for your separate tasks.  
For example, one tab for the frontend, second for the backend, and third for the markdown notes. Use vim the way it was meant to be used! Do not mimic an IDE

Use added features, like peek definition, to only enhance the way you vim around. For example, peek the definition with `<leader>k`,
open the reference in a split with `v`, and get to work! These patters appear everywhere in NoeVim.

No search and replace plugins. Put your big boy pants on and use the out of the box substitution!

Use the jumplist, marks, or flash to jump through the file. Use the mouse less!

## Keymappings

Mappings are strictly mnemonic. This makes them easy to learn overtime, and even easier to remember. The only exception will be `<leader>` with right hand homerow mappings.

Most mappings are labeled with a decriptive description in `keymaps.lua`. Some are in their respective plugins file in a `keys` lua table. I would use `<leader>sk` to search for key mappings if you are getting started. I have changed quite a bit of them.

Warning: I use jkl; instead of hjkl. I was getting wrist pain from contorting my wrist all the time. I believe it is because I used my wrists extremely heavily during my time as a musician.

If you think this mapping is ridiculous, I get it! It is the second block in the mappings file. Remove that and it should work as expected for you

### Colorschemes

This plugin has everysingle colorscheme I could think of. All lazily loaded. Keeping that ridiculously fast start time,
but providing _**you**_ with options :)

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

## Plugins

LspSaga - Peek definition, references, outlines, and open them in splits

Persistence - Restoring the previous session

Undotree - Show undos like version control, similar to Git

Indent Blankline - Indention lines with Treesitter

LazyGit - Quickly commit right from NoeVim

Telescope - Finding anything and everything!

Noice - Notification, search, cmdline, and pop-up border enhancements

DAP - Managed through LazyVim, provides a very nice debugger

Harpoon - Replacing buffer tabs, this lets you move between 'harpooned' files

Lualine - Help us know which window we are on, and gives git info

Neotree - File explorer configured to be a floating window

Toggleterm - A quick way to open and close a terminal. Great for running servers

UFO - Folding and unfolding blocks of code

Neoscroll - When using page up and down, it has a quick smooth scroll. This is way less disorienting, in my opinion

Markdown Support - Want to take notes using NoeVim? Simple markdown files are by far the best way. View your files with a live preview in the browser
