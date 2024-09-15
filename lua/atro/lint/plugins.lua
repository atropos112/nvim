local M = {}

M.lint_plugins = function()
	return {
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

				require("atro.lint.utils").install_linters()
				lint.linters_by_ft = require("atro.lint.configs").linter_configs()
			end,
		},
	}
end

return M
