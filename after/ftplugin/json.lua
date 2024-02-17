-- NOTE: Dependency sourcing
require("atro.utils.mason").install({
    -- linter
    "jsonlint",

    -- lsp
    "json-lsp",
})


-- NOTE: LSP
require('lspconfig').jsonls.setup {
    capabilities = Capabilities,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
        },
    },
}

-- NOTE: Linter
require("lint").linters_by_ft.json = { "jsonlint" }
