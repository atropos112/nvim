-- NOTE: Dependency sourcing
require("atro.utils.mason").install({
    -- linter
    "write-good",
    "proselint",
})

-- NOTE: Linter
require("lint").linters_by_ft.markdown = { "write_good", "proselint" }
