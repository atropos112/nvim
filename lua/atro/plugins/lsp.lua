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
        event = "LspAttach",
        opts = {
            include_declaration = false, -- Reference include declaration
            sections = {                 -- Enable / Disable specific request, formatter example looks 'Format Requests'
                definition = false,
                references = true,
                implements = true,
                git_authors = true,
            },
        }
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    }
}
