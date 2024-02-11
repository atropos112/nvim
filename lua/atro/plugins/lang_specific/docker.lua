vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "Dockerfile*", "docker-compose*.yml", "docker-compose*.yaml" },
    callback = function()
        require("atro.utils.mason").install({
            -- lsp
            "dockerfile-language-server",
            "docker-compose-language-service",

            -- linter
            "hadolint",
        })

        -- load linters (some are loaded in LSP stage)
        require("lint").linters_by_ft.dockerfile = { "hadolint" }
    end
})

return {}
