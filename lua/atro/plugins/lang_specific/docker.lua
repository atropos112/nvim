vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "Dockerfile*", "docker-compose*.yml", "docker-compose*.yaml" },
    callback = function()
        -- NOTE: Dependency sourcing
        require("atro.utils.mason").install({
            -- lsp
            "dockerfile-language-server",
            "docker-compose-language-service",

            -- linter
            "hadolint",
        })
        -- NOTE: LSP
        lsp = require("lspconfig")

        lsp.docker_compose_language_service.setup({
            on_attach = On_attach,
            capabilities = Capabilities,
        })
        lsp.dockerls.setup({
            on_attach = On_attach,
            capabilities = Capabilities,
        })

        -- NOTE: Linter
        require("lint").linters_by_ft.dockerfile = { "hadolint" }
    end
})

return {}
