local M = {}

-- Tried:
-- yamllint : stopped using it as its buggy.
-- statix: but its annoying to put up with the warning nvim produces about this.
M.linter_configs = {
	go = { "revive" },
	json = { "jsonlint" },
	python = { "ruff" },
	dockerfile = { "hadolint" },
	sh = { "shellcheck" },
}

return M
