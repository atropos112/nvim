return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            -- Lint on save
            vim.api.nvim_create_autocmd("TextChanged", {
                pattern = "*",
                callback = function()
                    require('lint').try_lint()
                end,
            })
        end,
    },
    {
        "rshkarin/mason-nvim-lint",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-lint"
        },
    },
}
