return {
  "ThePrimeagen/harpoon",
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    local telescope = require("telescope")
    local harpoon = require("harpoon")
    -- Setup Harpoon
    harpoon.setup({
      global_settings = {
        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
        save_on_toggle = false,

        -- saves the harpoon file upon every change. disabling is unrecommended.
        save_on_change = true,

        -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
        enter_on_sendcmd = false,

        -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
        tmux_autoclose_windows = false,

        -- filetypes that you want to prevent from adding to the harpoon list menu.
        excluded_filetypes = { "harpoon" },

        -- set marks specific to each git branch inside git repository.
        -- Each branch will have its own set of marked files.
        mark_branch = true,

        -- enable tabline with harpoon marks
        tabline = false,
        tabline_prefix = " ",
        tabline_suffix = " ",
      }
    })

    -- Setup Telescope extension for Harpoon
    telescope.load_extension("harpoon")

    -- Key mappings
    vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon: Mark File" })
    vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle Harpoon Menu" })

    vim.keymap.set("n", "<leader>hx", mark.add_file, { desc = "Harpoon: Mark File" })
    vim.keymap.set("n", "<leader>hn", function() ui.nav_next() end, { desc = "Harpoon: Next Mark" })
    vim.keymap.set("n", "<leader>hp", function() ui.nav_prev() end, { desc = "Harpoon: Previous Mark" })
    vim.keymap.set("n", "<leader>hm", function() telescope.extensions.harpoon.marks() end, { desc = "Harpoon: Show Marks with Telescope" })

    -- Telescope integration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        }):find()
    end

    vim.keymap.set("n", "<C-e>", function() toggle_telescope(mark.get_all()) end, { desc = "Open Harpoon with Telescope" })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
