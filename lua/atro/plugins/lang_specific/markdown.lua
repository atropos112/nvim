vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.md",
    callback = function()
        require("lint").linters_by_ft.json = { "jsonlint" }
        -- NOTE: Dependency sourcing
        require("atro.utils.mason").install({
            -- linter
            "write-good",
            "proselint",
        })

        -- NOTE: Linter
        require("lint").linters_by_ft.markdown = { "write_good", "proselint" }
    end
})

return {
    {
        -- INFO: Markdown preview functionality
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
        opts = {},
    },
    {
        -- INFO: Allows pasting images into markdown files
        "HakonHarnes/img-clip.nvim",
        ft = { "markdown" },
        event = "BufEnter",
        opts = {},
        keys = {
            { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
        },
    }
}
