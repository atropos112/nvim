vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "docker-compose.yaml", "docker-compose.yml" },
    callback = function()
        -- NOTE: Dependency sourcing
        require("atro.utils.mason").install({
            -- lsp
            "docker-compose-language-service",
        })

        require("lspconfig").docker_compose_language_service.setup {
            on_attach = On_attach,
            capabilities = Capabilities,
        }
    end
})

return {}
