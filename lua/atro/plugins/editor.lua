return {
    {
        "numToStr/Comment.nvim",
        opts = {}
    },
    {
        "mg979/vim-visual-multi",
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },

    -- Adds matching pairs of brackets, quotes, etc.
    {
        -- INFO: Autopairs plugin, adds matching pairs of brackets, quotes, etc.
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        -- INFO: Commenting plugin, allows commenting out lines and blocks of code
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = "LspAttach",
        -- INFO: zc folds, zo unfolds, below are extras
        keys = {
            { "zR", function() require("ufo").openAllFolds() end,  { desc = "Open all folds" } },
            { "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" } },
        },
        opts = {
            provider_selector = function(_, _, _)
                return { 'treesitter', 'indent' }
            end
        }
    },
    {
        'rmagatti/goto-preview',
        event = "BufRead",
        config = function()
            require('goto-preview').setup {}
            vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
                { noremap = true })
        end
    },
    {
        -- INFO: with :<n> you can peek at n-th line
        'nacro90/numb.nvim',
        event = "BufRead",
        opts = {}
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufRead",
        config = function()
            local tc = require("treesitter-context")
            vim.keymap.set("n", "[c", function() tc.go_to_context(vim.v.count1) end,
                { desc = "Go up a context", silent = true })
        end,
    },
    {
        "danymat/neogen",
        keys = {
            {
                "<leader>cc",
                function()
                    require("neogen").generate({})
                end,
                desc = "Neogen Comment",
            },
        },
        opts = { snippet_engine = "luasnip" },
    },
}
