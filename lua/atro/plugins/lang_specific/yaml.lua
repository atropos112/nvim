vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.yaml", "*.yml" },
    callback = function()
        -- NOTE: Dependency sourcing
        require("atro.utils.mason").install({
            -- linter
            "yamllint",

            -- lsp
            "yaml-language-server"
        })

        -- NOTE: LSP
        require('lspconfig').yamlls.setup {
            settings = {
                on_attach = On_attach,
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
        require("lint").linters_by_ft.nix = { "yamllint" }
    end
})

return {}
