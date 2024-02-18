vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.typ",
    callback = function(args)
        -- NOTE: Dependency sourcing
        require("atro.utils.mason").install({
            -- lsp
            "typst-lsp"
        })

        -- NOTE: LSP
        require('lspconfig').typst_lsp.setup {
            capabilities = Capabilities,
            on_attach = On_attach,
        }


        vim.api.nvim_buf_set_option(args.buf, 'filetype', 'typst')
    end
})

return {
    {
        'chomosuke/typst-preview.nvim',
        ft = 'typst',
        version = '0.1.*',
        build = function() require 'typst-preview'.update() end,
        opts = {},
    }
}
