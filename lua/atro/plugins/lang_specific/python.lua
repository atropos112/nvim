---@diagnostic disable: no-unknown
-- disabling because "True" is not a valid lua keyword but is used in pylsp...
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.py",
    callback = function()
        -- NOTE: Dependency sourcing
        require("atro.utils.mason").install({
            -- linter
            "ruff",

            -- formatter
            "black",

            -- lsp
            "pyright",

            -- debugger
            "debugpy",
        })


        -- NOTE: LSP
        local lsp = require('lspconfig')
        lsp.pyright.setup {
            on_attach = On_attach,
            capabilities = Capabilities,
        }

        -- NOTE: Linter
        require("lint").linters_by_ft.python = { "ruff" }
    end,
})

return {
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            -- NOTE: Debugger
            local dappy = require('dap-python')
            dappy.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python") -- thats where Mason will drop it
            dappy.test_runner = "pytest"
        end,
    },
}
