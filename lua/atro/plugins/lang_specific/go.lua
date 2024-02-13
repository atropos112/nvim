return {
    -- Debugging functionality for go
    {
        "leoluz/nvim-dap-go",
        event = "VeryLazy",
        ft = "go",
        config = function()
            -- NOTE: Debugger
            require('dap-go').setup {
                dap_configurations = {
                    {
                        type = "go",
                        name = "Attach remote",
                        mode = "remote",
                        request = "attach",
                    }
                },
            }
        end,

    },

    -- Golang plugin (all the lagnuage niceties in one plugin)
    {
        "fatih/vim-go",
        event = "VeryLazy",
        ft = "go",
        dependencies = {
            "mfussenegger/nvim-lint",
            "williamboman/mason.nvim",
        },
        config = function()
            -- NOTE: Dependency sourcing
            require("atro.utils.mason").install({
                -- lsp
                "gopls",

                -- linter
                "revive",
                "typos"
            })

            -- NOTE: LSP
            require("lspconfig").gopls.setup({
                on_attach = On_attach,
                capabilities = Capabilities,
            })

            -- NOTE: Linter
            require("lint").linters_by_ft.markdown = { "revive", "typos" }
        end,
    }
}
