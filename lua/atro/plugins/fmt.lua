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

			-- INFO: List of available linters can be found here
			-- https://github.com/stevearc/conform.nvim#formatters
			require("conform").setup({
				formatters_by_ft = {
					python = { "ruff_fix", "ruff_format" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
}
