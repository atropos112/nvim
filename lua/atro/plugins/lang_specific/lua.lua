vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.lua",
    callback = function()
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
    end
})

return {}
