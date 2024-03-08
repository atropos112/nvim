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

			-- Tried:
			-- yamllint : stopped using it as its buggy.
			-- statix: but its annoying to put up with the warning nvim produces about this.
			lint.linters_by_ft = {
				go = { "revive" },
				json = { "jsonlint" },
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
			automatic_installation = true,
		},
	},
}
