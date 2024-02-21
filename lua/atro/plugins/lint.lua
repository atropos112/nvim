return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            -- Lint on save
            vim.api.nvim_create_autocmd("TextChanged", {
                pattern = "*",
                callback = function() lint.try_lint() end,
            })

            lint.linters_by_ft = {
                go = { "revive" },
                json = { 'jsonlint' },
                yaml = { 'yamllint' },
                markdown = { "markdownlint" },
                python = { 'ruff' },
                dockerfile = { 'hadolint' },
                nix = { 'statix' }, -- NOTE: has to be manually installed (mason does not support it yet)
                sh = { 'shellcheck' },
            }
        end,
    },
    {
        "rshkarin/mason-nvim-lint",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-lint"
        },
        opts = {
            automatic_installation = true,
        }
    },
}
