-- INFO: Fmt = Formatter
-- INFO: A formatter is another mechanism that helps ensure a standard output from the variable and sometimes inconsistent value input.
return {
	{
		"stevearc/conform.nvim",
		event = { "BufRead", "BufNewFile" },
		config = function()
			require("atro.utils.mason").install({
				-- python
				"ruff",
			})
			local conform = require("conform")

			-- INFO: List of available linters can be found here
			-- https://github.com/stevearc/conform.nvim#formatters
			conform.setup({
				formatters_by_ft = {
					python = { "ruff_fix", "ruff_format" },
				},
			})

			require("atro.utils.generic").keyset("n", "<A-s>", function()
				require("conform").format()
				vim.cmd("w")
			end, { desc = "Format and save" })
		end,
	},
}
