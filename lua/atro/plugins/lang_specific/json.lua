vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.json",
    callback = function()
        require("atro.utils.mason").install({
            -- linter
            "jsonlint",

            -- lsp 
            "json-lsp",
        })

        -- load linters (some are loaded in LSP stage)
        require("lint").linters_by_ft.json= { "jsonlint" } 

        require('lspconfig').jsonls.setup{
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                },
            },
        }
    end
})

return {}
      

