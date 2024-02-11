local linters = {
	markdown = {
		"write-good",
	},
	yaml = { "yamllint" },
	go = {"revive", "typos" },
	dockerfile = { "hadolint" },
	python = { "mypy", "pylint", "vulture" },
	json = { "jsonlint" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	cpp = { "cpplint" },
}

return {
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			
			-- Loading more linters than I am asking from mason
			-- This is because some linters are not in mason but I do want them
			linters_with_extra = {
				nix = { "statix" } -- statix has to be installed manually not via Mason :(
			}

			-- Adding the linters above to existing table
			for ft, linters in pairs(linters) do
				for _, linter in ipairs(linters) do
					if linters_with_extra[ft] then
						table.insert(linters_with_extra[ft], linter)
					else
						linters_with_extra[ft] = { linter }
					end
				end
			end

			lint.linters_by_ft = linters_with_extra

			-- Lint on text chagne
			vim.api.nvim_create_autocmd("TextChanged", {
				pattern = "*",
				callback = function()
					require('lint').try_lint()
				end,
			})
		end,
	},
	{
		"rshkarin/mason-nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-lint"
		},
		config = function()
			mlint = require("mason-nvim-lint")
			ensure_installed = {}
			for ft, linters in pairs(linters) do
				for _, linter in ipairs(linters) do
					table.insert(ensure_installed, linter)
				end
			end

			mlint.setup({
				-- tries to figure out all linters needed automatically baesed on
				-- lsp's installed, but it fails and just shows a warning instead.
				automatic_installation = false,
				ensure_installed = ensure_installed,
			})
		end,
	},
}
