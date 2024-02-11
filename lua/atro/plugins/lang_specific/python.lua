vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.py",
    callback = function()
        -- get resources
        require("atro.utils.mason").install({
            -- linter
            "mypy", 
            "pylint", 
            "vulture",
            "ruff", -- its also a formatter

            -- lsp 
            "jedi-language-server",
            "pyright",
            "python-lsp-server",
            "pyre",
            "ruff-lsp",

            -- debugger
            "debugpy",
        })

        -- load linters (some are loaded in LSP stage)
        require("lint").linters_by_ft.python = {"vulture" } 

        -- load lsp
        require('lspconfig').pylsp.setup{
            settings = {
                -- See https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md for more info
                pylsp = {
                    plugins = {
                        ruff = {
                            enabled = true,
                            lineLength = 200,
                        },
                        pylsp_mypy = { 
                            enabled = true,
                            overrides = {"--check-untyped-defs", True}
                        },
                        pylint = { 
                            enabled = true,
                            args = {
                                "--max-line-length=200", 
                                "--disable=C0114", -- C0114: Missing module docstring
                                "--disable=R0903", -- R0903 too-few-public-methods on a class
                                True
                            },
                        },
                        pycodestyle = {
                            maxLineLength = 200,
                            ignore = {
                                "E111", -- indentation is not a multiple of four
                                "E121", -- continuation line under-indented for hanging indent
                                "W291", -- blank line contains whitespace
                                "W293", -- continuation line contains whitespace
                            },

                        }
                    }
                }
            }
        }
    end,

})

return {
    {
        "mfussenegger/nvim-dap-python",
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            dappy = require('dap-python')
            dappy.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python") -- thats where Mason will drop it
            dappy.test_runner = "pytest"
        end,
    },
}