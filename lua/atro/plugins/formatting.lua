return {
    {
        "sbdchd/neoformat",
        event = "BufWritePost", -- load on save
    },
    {
        "elentok/format-on-save.nvim",
        event = "BufWritePost", -- load on save
        config = function()
            local format_on_save = require("format-on-save")
            local formatters = require("format-on-save.formatters")

            format_on_save.setup({
                exclude_path_patterns = {
                    "/node_modules/",
                },
                formatter_by_ft = {
                    go = formatters.lsp,
                    json = formatters.lsp,
                    lua = formatters.lsp,
                    csharp = formatters.lsp,
                    rust = formatters.lsp,
                    sh = formatters.shfmt,

                    yaml = {
                        formatters.lsp,
                        formatters.prettierd,
                    },

                    python = {
                        formatters.remove_trailing_whitespace,
                        formatters.ruff,
                    },
                    nix = {
                        formatters.shell({ cmd = { "alejandra", "-qq" } })
                    },
                },

                -- fallback_formatter
                fallback_formatter = {},

                -- By default, all shell commands are prefixed with "sh -c" (see PR #3)
                -- To prevent that set `run_with_sh` to `false`.
                run_with_sh = false,
            })

            require("atro.utils.mason").install("prettierd")
        end,
    }
}
