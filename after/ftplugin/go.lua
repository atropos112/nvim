-- NOTE: Dependency sourcing
require("atro.utils.mason").install({
    -- lsp
    "gopls",

    -- linter
    "revive",
    "typos"
})

-- WARN: vim-go provides its own LSP setup for gopls,
-- WARN: if you try to add your own it will conflict with it.

-- NOTE: Linter
require("lint").linters_by_ft.markdown = { "revive", "typos" }

-- NOTE: Debugger
require('dap-go').setup {
    dap_configurations = {
        {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
        }
    },
}
