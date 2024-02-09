
local lint = require("lint")


-- Names with dashes (-) have to be modified i.e.
-- write_good -> write_good
-- golangci-lint -> golangcilint
-- There doesn't seem to be much of consistency here so "try and see"
lint.linters_by_ft = {
    markdown = { "write_good" },
	yaml = { "actionlint", "yamllint" },
	go = {"revive", "typos" },
	dockerfile = { "hadolint" },
	python = { "mypy", "pylint", "ruff", "vulture" },
	json = { "jsonlint" },
	lua = { "luacheck" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	cpp = { "cpplint" },
	nix = { "statix" }, -- statix has to be installed manually not via Mason :(
}

vim.api.nvim_create_autocmd("TextChanged", {
    pattern = "*",
    callback = function()
        require('lint').try_lint()
    end,
})
