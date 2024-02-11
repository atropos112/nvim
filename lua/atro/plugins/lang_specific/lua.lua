vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.lua",
    callback = function()
        require("atro.utils.mason").install({
            -- lsp 
            "lua-language-server"
        })

        require('lspconfig').lua_ls.setup{
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
      
