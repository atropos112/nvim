vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

return {
    {
        "neovim/nvim-lspconfig",
    },
    {
        "b0o/schemastore.nvim"
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig"
        },
        config = function()
            require("mason").setup()
            Capabilities = require("cmp_nvim_lsp").default_capabilities(Capabilities)
            require("mason-lspconfig").setup({})

            vim.keymap.set('n', '<leader>of', function() vim.diagnostic.open_float() end, { desc = "Diagnostic float" })
        end,
    },
    {
        'VidocqH/lsp-lens.nvim',
        config = function()
            require 'lsp-lens'.setup({})
        end,
    },
}
