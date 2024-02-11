vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.nix",
    callback = function()
        require("atro.utils.mason").install({
            -- lsp 
            "nil",
            "rnix-lsp",
        })

        require("lint").linters_by_ft.nix = { "statix" } -- has to be manually installed (mason does not support it yet)
    end
})

return {}
