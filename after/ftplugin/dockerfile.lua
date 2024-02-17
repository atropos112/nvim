-- NOTE: Dependency sourcing
require("atro.utils.mason").install({
    -- lsp
    "dockerfile-language-server",

    -- linter
    "hadolint",
})

-- NOTE: LSP
local lsp = require("lspconfig")

lsp.dockerls.setup({
    capabilities = Capabilities,
})

-- NOTE: Linter
require("lint").linters_by_ft.dockerfile = { "hadolint" }
