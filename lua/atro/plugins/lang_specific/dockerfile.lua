vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "Dockerfile*" },
    callback = function()
        -- NOTE: Dependency sourcing
        require("atro.utils.mason").install({
            -- lsp
            "dockerfile-language-server",

            -- linter
            "hadolint",
        })

        -- NOTE: LSP
        require("lspconfig").dockerls.setup({
            on_attach = On_attach,
            capabilities = Capabilities,
        })

        -- NOTE: Linter
        require("lint").linters_by_ft.dockerfile = { "hadolint" }
    end
})

return {}
