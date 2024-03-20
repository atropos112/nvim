return {
	{
		"mfussenegger/nvim-lint",
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

			-- Tried:
			-- yamllint : stopped using it as its buggy.
			-- statix: but its annoying to put up with the warning nvim produces about this.
			-- INFO: List of available linters can be found here
			lint.linters_by_ft = {
				python = { "ruff" },
				dockerfile = { "hadolint" },
				sh = { "shellcheck" },
			}
		end,
	},
	{
		"rshkarin/mason-nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-lint",
		},
		opts = {
			automatic_installation = false,
		},
	},
}
