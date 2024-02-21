return {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        lazy = true,
        build = "make",
    },
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        config = function()
            local telescope = require('telescope')
            ---@diagnostic disable-next-line: no-unknown
            local builtin = require('telescope.builtin')
            telescope.setup({
                extensions = {
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    }
                }
            })

            telescope.load_extension('fzf')

            -- TODO: Add more keymaps
            local set = require('atro.utils.generic').keyset
            set('n', ';f', builtin.find_files, {})
            set('n', ';o', builtin.oldfiles, {})
            set('n', ';g', builtin.live_grep, {})
            set('n', ';b', builtin.buffers, {})
        end
    },
}
