# NoeVim

*Get it?*

This is a fork of LazyVim, which makes the much more complex tasks like lsp, treesitter etc, very easy to maintain or not maintain at all really. 

## Plugins

LspSaga - For peek definition, breaaadcrumbs and better goto definition UX

Persistence - Restoring previous session

Undotree - Show undos like version control, similar to Git

Indent Blankline - Indention lines to make the text context more clear. Highlights the scope with treesitter integration

LazyGit - for quick commits. I would suggest you only use it for that though!

Telescope - Finding anything and everything! 

Noice - Notification, search, cmdline, and border enhancement

DAP - Managed through LazyVim, provides a very nice debugger. Like an IDE

Harpoon - Replacing tabs, this lets you move between 'harpooned' files

Lualine - Help us know which window we are on, and gives git info

Neotree - File explorer configured to be a floating window

Portal - To teleport with the changelist and jumplist. Similar to Harpoon 

Neorg - I only really used Notion for its headers and code blocks. Now I can do the exact same thing with nvim! 

Toggleterm - VSCode-like terminal. Great for when you are practicing you DSA and you just need to run a command/script

UFO - Folding and unfolding blocks of code 

Copilot - I am trying to use AI less in general as it makes me literally worse, so this might go soon

Neoscroll - When using page up and down, it has a quick smooth scroll. This is way less disorienting, in my opinion 

## Extremely Fast!!!

NoeVim loads in about 55 miliseconds on average! It only loads the essentials like Telescope, Treesitter, and the colorscheme on load. 
Everything is loaded direcly afterwards. This gives the illusion that nvim is loaded instantly!

## Keymappings

Most mappings are labeled with a decriptive description in ```keymaps.lua```. Some are in their respective plugins file in a ```keys``` lua table. I would use ```<leader>sk``` to search for key mappings if you are getting started. I have changed quite a bit of them. 

Warning: I use jkl; instead of hjkl. I was getting wrist pain from contorting my wrist all the time. I believe it is because I used my wrists extremely heavily during my time as a musician. 

If you think this mapping is ridiculous, I get it! It is the second block in the mappings file. Remove that and it should work as expected for you

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
