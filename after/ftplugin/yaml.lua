-- NOTE: Dependency sourcing
require("atro.utils.mason").install({
    -- lsp
    "yaml-language-server"
    "docker-compose-language-service",

    -- linter
    "yamllint",
})

-- NOTE: LSP
local lsp = require("lspconfig")

lsp.docker_compose_language_service.setup({
    capabilities = Capabilities,
})
lsp.yamlls.setup {
    settings = {
        capabilities = Capabilities,
        yaml = {
            schemaStore = {
                enable = false,
                url = "",
            },
            schemas = require('schemastore').yaml.schemas {
                extra = {
                    url = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json',
                    name = 'Argo CD Application',
                    fileMatch = 'argocd-application.yaml'
                }
            },
        },
    },
}

-- NOTE: Linter
require("lint").linters_by_ft.yaml = { "yamllint" }
