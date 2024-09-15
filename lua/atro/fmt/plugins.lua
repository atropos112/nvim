local M = {}

M.fmt_plugins = function()
	---@type LazySpec[]
	local plugins = {
		{
			"stevearc/conform.nvim",
			event = { "BufRead", "BufNewFile" },
			config = function()
				require("atro.fmt.utils").install_fmts()

				local conform = require("conform")

				-- custom settings
				conform.formatters.yamlfmt = {
					prepend_args = function(_, _)
						return {
							"-formatter",
							-- WARN: This is a custom configuration for yamlfmt. Main concern was it mushing multiline strings into one line. It doesn't do that AS long as there is at MOST one comment line in the multi string. A compromise for sure.
							"scan_folded_as_literal=true,retain_line_breaks=true,include_document_start=true",
						}
					end,
				}

				-- INFO: List of available linters can be found here
				-- https://github.com/stevearc/conform.nvim#formatters
				conform.setup({
					formatters_by_ft = require("atro.fmt.configs").fmt_configs(),

					require("atro.utils.generic").keyset({ "n", "v", "i" }, "<C-s>", function()
						require("conform").format()
						vim.cmd("w")
					end, { desc = "Format and save" }),
				})
			end,
		},
	}

	return plugins
end

return M
