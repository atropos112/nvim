return {
    -- Debugging functionality for go
    {
        "leoluz/nvim-dap-go",
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
            -- WARN: vim-go provides its own LSP setup for gopls, and thats why no On_Attach or Capabilities are defined here.
            require("lspconfig").gopls.setup({})

            -- NOTE: Linter
            require("lint").linters_by_ft.markdown = { "revive", "typos" }
        end,
    }
}
