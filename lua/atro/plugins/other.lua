return {
    -- API info of vim
    {
        "folke/neodev.nvim",
        event = "VeryLazy",
        opts = {
            library = { plugins = { "neotest" }, types = true },
        },
    },

    -- Tract time usage
    {
        "wakatime/vim-wakatime",
        event = "BufRead",
    },

    -- Downloads dependencies for LSP, formatter and debugger
    {
        "williamboman/mason.nvim",
        opts = {}
    },

    -- Tells you what keybindings are available
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },

    -- Keep track of startup time
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },
    -- Smooth scrolling
    {
        "karb94/neoscroll.nvim",
        config = function()
            require('neoscroll').setup({
                -- Set any options as needed
            })

            local t    = {}
            -- Syntax: t[keys] = {function, {function arguments}}
            t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '150' } }
            t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '150' } }
            t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '250' } }
            t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '250' } }
            t['<C-y>'] = { 'scroll', { '-0.10', 'false', '30' } }
            t['<C-e>'] = { 'scroll', { '0.10', 'false', '30' } }
            t['zt']    = { 'zt', { '150' } }
            t['zz']    = { 'zz', { '150' } }
            t['zb']    = { 'zb', { '150' } }

            require('neoscroll.config').set_mappings(t)
        end
    },
    {
        "tris203/hawtkeys.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {}
    },
    {
        "m4xshen/hardtime.nvim",
        event = "BufRead",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim"
        },
        opts = {
            max_count = 8,
            restriction_mode = "hint", -- Might change it to "block" at some point.
            -- INFO: I like arrow keys, in insert mode, and disagree with it being a bad pactice ESC + l + i is more steps then arrow right. Only argument on the other side here is that arrow keys are far from where fingers typically are but I use moonlander zsa keyboard so this doesn't apply to me (my thumbs are always near arrows anyway).
            disabled_keys = {
                ["<Up>"] = {},
                ["<Down>"] = {},
                ["<Left>"] = {},
                ["<Right>"] = {}
            },
            restricted_keys = {
                ["<C-N>"] = {},
                ["<Up>"] = { "i", "n" },
                ["<Down>"] = { "i", "n" },
                ["<Left>"] = { "i", "n" },
                ["<Right>"] = { "i", "n" }
            }
        }
    },
    -- INFO: Better increase/descrease, works on versions, dates, bools etc.
    {
        "monaqa/dial.nvim",
        -- stylua: ignore
        keys = {
            { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
            { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
        },
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group({
                default = {
                    augend.integer.alias.decimal,
                    augend.integer.alias.hex,
                    augend.date.alias["%Y/%m/%d"],
                    augend.constant.alias.bool,
                    augend.semver.alias.semver,
                    augend.constant.new({ elements = { "let", "const" } }),
                },
            })
        end,
    },
}
