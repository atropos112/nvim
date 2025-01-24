---@type LazySpec[]
return {
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",
		config = function()
			local conform = require("conform")

			local log = LOGGER:with({ phase = "FMT" })
			log:info("Starting FMT setup")

			local formatters_by_ft = {}
			for lang, cfg in pairs(CONFIG.languages) do
				if cfg.formatters then
					log:with({ language = lang }):debug("Including formatter(s): " .. vim.inspect(cfg.formatters))
					local formatters = {}
					for fmt_name, fmt_cfg in pairs(cfg.formatters) do
						if fmt_cfg ~= {} then
							conform.formatters[fmt_name] = fmt_cfg
						end
						formatters[#formatters + 1] = fmt_name
					end

					formatters_by_ft[lang] = formatters
				end
			end

			-- INFO: List of available linters can be found here
			-- https://github.com/stevearc/conform.nvim#formatters
			conform.setup({ formatters_by_ft = formatters_by_ft })

			---@param keymap string
			local fmt_and_write_keymap = function(keymap)
				require("atro.utils").keyset({ "n", "v", "i" }, keymap, function()
					require("conform").format()
					vim.cmd("w")
				end, { desc = "Format and save" })
			end

			fmt_and_write_keymap("<A-s>")
			fmt_and_write_keymap("ß")
		end,
	},
}
