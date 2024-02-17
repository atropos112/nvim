-- NOTE: Dependency sourcing
require("atro.utils.mason").install({
    -- lsp
    "lua-language-server"
})

-- NOTE: LSP
require('lspconfig').lua_ls.setup {
    capabilities = Capabilities,
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}
