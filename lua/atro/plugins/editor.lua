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
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        init = function()
        end,
        config = function()
            local ufo = require("ufo")
            ufo.setup()
            -- INFO: zc folds, zo unfolds, below are extras
            vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
            vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
        end,
    },
    {
        'rmagatti/goto-preview',
        event = "BufRead",
        config = function()
            require('goto-preview').setup {}
            vim.keymap.set("n", "gt", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})
        end
    }
}
