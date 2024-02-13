return {
    {
        "iabdelkareem/csharp.nvim",
        ft = "cs",
        dependencies = {
            "williamboman/mason.nvim", -- Required, automatically installs omnisharp
            "Tastyep/structlog.nvim",  -- Optional, but highly recommended for debugging
        },
        config = function()
            -- NOTE: Dependency sourcing
            require("atro.utils.mason").install({
                -- lsp
                "omnisharp",

                -- debugger
                "netcoredbg",
            })

            -- INFO: Plugin specific
            local csharp = require("csharp")
            csharp.setup({
                lsp = {
                    analyze_open_documents_only = true,
                    enable_editor_config_support = true,
                }
            })
            vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '', {
                noremap = true,
                silent = true,
                callback = function()
                    csharp.go_to_definition()
                end
            })

            -- NOTE: LSP
            require("lspconfig").omnisharp.setup({
                -- WARN: we do not attach "on_attach" as plugin adds its own
                capabilities = Capabilities,
            })


            -- NOTE: Debugger
            local dap = require('dap')
            dap.adapters.netcoredbg = {
                type = 'executable',
                command = 'netcoredbg',
                args = { '--interpreter=vscode' }
            }

            dap.configurations.cs = {
                {
                    type = "netcoredbg",
                    name = "launch - netcoredbg",
                    request = "launch",
                    program = function()
                        ---@diagnostic disable-next-line
                        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                    end,
                },
            }
        end
    }
}
