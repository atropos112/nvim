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

				-- csharp
				"csharpier",

				-- json
				"fixjson",

				-- markdown
				"prettier",

				-- shell
				"shfmt",
				"shellharden",

				-- yaml
				"yamlfmt",

				-- toml
				"taplo",

				-- lua
				"stylua",

				-- go
				"goimports",

				-- Nix
				"nixpkgs-fmt",
			})

			-- INFO: List of available linters can be found here
			-- https://github.com/stevearc/conform.nvim#formatters
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_fix", "ruff_format" },
					cs = { "csharpier" },
					go = { "gofmt", "goimports" },
					json = { "fixjson" },
					just = { "just" },
					md = { "mdformat" },
					sh = { "shfmt", "shellharden" },
					yaml = { "yamlfmt" },
					toml = { "taplo" },
					markdown = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
}
