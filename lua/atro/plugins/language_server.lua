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
        end,
    },
}
