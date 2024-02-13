return {
    {
        "Decodetalkers/csharpls-extended-lsp.nvim",
        ft = "cs",
        config = function()
            -- NOTE: Dependency sourcing
            require("atro.utils.mason").install({
                -- lsp
                "csharp-language-server",

                -- debugger
                "netcoredbg",
            })

            -- NOTE: LSP
            require("lspconfig").csharp_ls.setup({
                on_attach = On_attach,
                capabilities = Capabilities,
                handlers = {
                    ["textDocument/definition"] = require('csharpls_extended').handler,
                    ["textDocument/typeDefinition"] = require('csharpls_extended').handler,
                },
                cmd = { "csharp-ls" },
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
        end,
    }
}
