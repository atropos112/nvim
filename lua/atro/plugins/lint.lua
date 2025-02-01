---@type LazySpec[]
return {
	{
		"mfussenegger/nvim-lint",
		event = { "VeryLazy" },
		config = function()
			local lint = require("lint")
			local utils = require("atro.utils")
			local log = LOGGER:with({ phase = "Lint" })

			log:info("Starting lint setup")

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

			local git_root = utils.GetGitRoot()
			if git_root then
				local potential_markdownlint_config = git_root .. "/.markdownlint.yaml"
				if utils.file_exists(potential_markdownlint_config) then
					log:debug("Found markdownlint config at: " .. potential_markdownlint_config .. ". Adjusting markdownlint args accordingly.")
					lint.linters.markdownlint.args = {
						"--config",
						potential_markdownlint_config,
						"--stdin",
					}
				end
			end

			local linters_by_ft = {}
			for lang, cfg in pairs(CONFIG.languages) do
				if cfg.linters then
					log:debug("Including linters(s): " .. utils.lst_to_str(cfg.linters))
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
