local M = {}

M.linter_configs = function()
	if _G._linter_configs then
		return _G._linter_configs
	end

	-- Lazy eval
	if require("atro.utils.generic").file_exists(vim.fn.stdpath("config") .. "/lua/atro/lint/overrides.lua") then
		_G._linter_configs = require("atro.lint.overrides").linter_configs()
	else
		-- Tried:
		-- yamllint : stopped using it as its buggy.
		-- statix: but its annoying to put up with the warning nvim produces about this.
		_G._linter_configs = {
			go = { "golangcilint" }, -- golangcilint has a lot of linters built in.
			json = { "jsonlint" },
			python = { "ruff" },
			dockerfile = { "hadolint" },
			sh = { "shellcheck" },
		}

		for lang, linters in pairs(_G._linter_configs) do
			-- add codespell to all linters
			linters[#linters + 1] = "codespell"
			_G._linter_configs[lang] = linters
		end
	end

	return _G._linter_configs
end

return M
