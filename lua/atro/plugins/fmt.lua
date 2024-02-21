-- INFO: Fmt = Formatter
-- INFO: A formatter is another mechanism that helps ensure a standard output from the variable and sometimes inconsistent value input.
return {
    {
        'stevearc/conform.nvim',
        event = { "BufRead", "BufNewFile" },
        config = function()
            require("atro.utils.mason").install({
                -- python
                "isort",
                "black",

                -- csharp
                "csharpier",

                -- json
                "fixjson",

                -- markdown
                "mdformat",

                -- shell
                "shfmt",

                -- yaml
                "yamlfix",
                "yamlfmt",
            })

            require("conform").setup({
                formatters_by_ft = {
                    python = { "isort", "black" },
                    nix = { "alejandra" }, -- INFO: This is installed via NixOS, no Mason support.
                    cs = { "csharpier" },
                    go = { "gofmt" },
                    json = { "fixjson" },
                    just = { "just" },
                    md = { "mdformat" },
                    sh = { "shfmt" },
                    yaml = { "yamlfix", "yamlfmt" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },

            })
        end,
    },
}
