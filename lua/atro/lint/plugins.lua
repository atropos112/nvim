local M = {}

M.lint_plugins = function()
	if _G.lint_plugins then
		return _G.lint_plugins
	end

	_G.lint_plugins = {
		{
			"mfussenegger/nvim-lint",
			event = { "BufRead", "BufNewFile" },
			config = function()
				local lint = require("lint")

				-- Lint on save
				vim.api.nvim_create_autocmd("TextChanged", {
					pattern = "*",
					callback = function()
						lint.try_lint()
					end,
				})

				-- To see what the defaults are go to https://github.com/mfussenegger/nvim-lint/tree/master/lua/lint/linters
				-- Here I am changing default args for hadolint to do some ignores
				lint.linters.hadolint.args = {
					"--ignore=DL3007",
					"-f",
					"json",
					"-",
				}

				lint.linters.codespell.args = {
					"-L",
					"noice,AfterAll", -- Ignore words separated by commas
					"--stdin-single-line",
					"-",
				}

				lint.linters_by_ft = require("atro.lint.configs").linter_configs()
			end,
		},
	}

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})

	return _G.lint_plugins
end

return M
