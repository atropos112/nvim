---@type LazySpec[]
return {
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		config = function()
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
			local log = LOGGER:with({ phase = "FMT" })
			log:info("Starting FMT setup")

			local formatters_by_ft = {}
			for lang, cfg in pairs(GCONF.languages) do
				if cfg.formatters then
					log:with({ language = lang }):debug("Including formatter(s): " .. require("atro.utils").lst_to_str(cfg.formatters))
					formatters_by_ft[lang] = cfg.formatters
				end
			end
			-- GCONF.talk_to_external = false

			-- INFO: List of available linters can be found here
			-- https://github.com/stevearc/conform.nvim#formatters
			conform.setup({ formatters_by_ft = formatters_by_ft })

			require("atro.utils").keyset({ "n", "v", "i" }, "<C-s>", function()
				require("conform").format()
				vim.cmd("w")
			end, { desc = "Format and save" })
		end,
	},
}
