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
