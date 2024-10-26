---@type LazySpec[]
return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufRead", "BufNewFile" },
		config = function()
			local lint = require("lint")

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

			local log = LOGGER:with({ phase = "Lint" })
			log:info("Starting lint setup")

			local linters_by_ft = {}
			for lang, cfg in pairs(GCONF.languages) do
				if cfg.linters then
					log:debug("Including linters(s): " .. require("atro.utils").lst_to_str(cfg.linters))
					linters_by_ft[lang] = cfg.linters
				end
			end

			lint.linters_by_ft = linters_by_ft

			-- Lint on save
			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
				pattern = "*",
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
