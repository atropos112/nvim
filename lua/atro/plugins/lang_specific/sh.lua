vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.sh", "*.bash", "*.zsh", "*.shrc", "*.bashrc", "*.zshrc", "*.bash_profile", "*.zsh_profile", "*.bash_login", "*.zsh_login", "*.bash_logout", "*.zsh_logout", "*.bash_aliases", "*.zsh_aliases", "*.bash_history", "*.zsh_history" },
    callback = function()
        -- NOTE: Dependency sourcing
        require("atro.utils.mason").install({
            -- lsp
            "bash-language-server",

            -- linter
            "shellcheck",
        })

        -- NOTE: Linter
        require("lint").linters_by_ft.sh = { "shellcheck" }
        require("lint").linters_by_ft.bash = { "shellcheck" }
    end
})

return {}
