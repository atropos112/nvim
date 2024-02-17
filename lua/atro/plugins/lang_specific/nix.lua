vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.nix",
    callback = function()
        -- NOTE: Dependency sourcing
        require("atro.utils.mason").install({
            -- lsp
            "nil",
            "rnix-lsp",
        })

        -- NOTE: LSP
        local lsp = require('lspconfig')
        local config = {
            capabilities = Capabilities,
        }
        lsp.rnix.setup(config)
        lsp.nil_ls.setup(config)

        -- NOTE: Linter
        require("lint").linters_by_ft.nix = { "statix" } -- has to be manually installed (mason does not support it yet)
    end
})

return {}
