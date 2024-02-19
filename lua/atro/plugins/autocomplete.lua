return {
    -- Github Copilot
    {
        "zbirenbaum/copilot.lua",
        event = "VeryLazy",
        opts = {
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<C-CR>",
                },
            },

        }
    },
    --- Main autocomplete plugin
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-emoji",
            "rafamadriz/friendly-snippets",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            --- cmp is responsible for autocomplete
            --- also load here luasnip snippets using snippets from vs-code
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup {}

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    -- C-n and C-p to go back and forward in autocomplete
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    -- C-d and C-f to stroll back and forward in docs of autocomplete
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    -- Tab and Shift-Tab to go forward and backward in autocomplete just like C-n and C-p.
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'calc' },
                    { name = 'tmux' },
                    { name = 'emoji' }
                },
            }
        end,
    },
}
