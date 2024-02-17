return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
        config = function()
            -- NOTE: Dependency sourcing
            require("atro.utils.mason").install({
                -- linter
                "write-good",
                "proselint",
            })

            -- NOTE: Linter
            require("lint").linters_by_ft.markdown = { "write_good", "proselint" }
        end,
    },
}
