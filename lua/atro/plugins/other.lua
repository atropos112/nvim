return {

    -- Tract time usage
    "wakatime/vim-wakatime",

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

    -- Nice loading graphics (on bottom right)
    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        tag = "legacy",
        config = function()
            require("fidget").setup {}
        end,
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
        "m4xshen/hardtime.nvim",
        event = "BufRead",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim"
        },
        opts = {
            max_count = 12,
        }
    }
}
