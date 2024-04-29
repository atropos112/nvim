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
			})
			local conform = require("conform")
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
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_fix", "ruff_format" },
					cs = { "csharpier" },
					go = { "gofmt", "goimports" },
					json = { "fixjson" },
					just = { "just" },
					nix = { "alejandra" },
					md = { "mdformat" },
					sh = { "shfmt", "shellharden" },
					yaml = { "yamlfmt" },
					toml = { "taplo" },
					markdown = { "prettier" },
				},

				require("atro.utils.generic").keyset({ "n", "v", "i" }, "<C-s>", function()
					require("conform").format()
					vim.cmd("w")
				end, { desc = "Format and save" }),
			})
		end,
	},
}
