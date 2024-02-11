return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        depends = {
            "mfussenegger/nvim-lint",
            "williamboman/mason.nvim",
        },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        config = function()
            require("atro.utils.mason").install({
                -- linter
                "write-good",

                -- lsp
                "prosemd-lsp",
            })
            require("lint").linters_by_ft.markdown = { "write_good" }
        end
    },
}
