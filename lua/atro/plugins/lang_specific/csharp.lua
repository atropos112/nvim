return {
    {
        "Decodetalkers/csharpls-extended-lsp.nvim",
        ft = "cs",
        config = function()
            -- NOTE: Dependency sourcing
            require("atro.utils.mason").install({
                -- debugger
                "netcoredbg",
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
