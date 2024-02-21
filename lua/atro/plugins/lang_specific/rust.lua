return {
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        ft = { "rust" },
        config = function()
            -- NOTE: Dependency sourcing
            require("atro.utils.mason").install("codelldb")

            -- NOTE: Debugger
            local dap = require("dap")

            dap.adapters.codelldb = {
                type = 'server',
                port = '${port}',
                executable = {
                    -- assuming codelldb is in your PATH
                    command = "codelldb",
                    args = { '--port', '${port}' },
                },
            }

            dap.configurations.rust = {
                {
                    name = 'Debug with codelldb',
                    type = 'codelldb',
                    request = 'launch',
                    program = function()
                        -- we build first
                        vim.fn.jobstart('cargo build', {
                            on_exit = function(_, code)
                                if code == 0 then
                                    vim.notify('Build successful')
                                else
                                    vim.notify('Build failed')
                                end
                            end
                        })
                        local parent = vim.fn.fnamemodify(vim.fn.getcwd(), ':h')
                        -- then we run the program
                        return parent .. '/target/debug/' .. vim.fn.fnamemodify(parent, ':t')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }
        end,
    },
    {
        'saecki/crates.nvim',
        tag = 'stable',
        ft = { "toml" },
        config = function()
            require('crates').setup()
        end,
    }
}
