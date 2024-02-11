return {
	{
		"sbdchd/neoformat",
		event = "BufWritePost", -- load on save
	},
	{
		"elentok/format-on-save.nvim",
		event = "BufWritePost", -- load on save
		config = function()
			local format_on_save = require("format-on-save")
			local formatters = require("format-on-save.formatters")
			local registry = require("mason-registry")

			format_on_save.setup({
				exclude_path_patterns = {
					"/node_modules/",
				},
				formatter_by_ft = {
					css = formatters.lsp,
					html = formatters.lsp,
					java = formatters.lsp,
					javascript = formatters.lsp,
					json = formatters.lsp,
					lua = formatters.lsp,
					csharp = nil,
					markdown = formatters.prettierd,
					openscad = formatters.lsp,
					rust = formatters.lsp,
					scad = formatters.lsp,
					scss = formatters.lsp,
					sh = formatters.shfmt,
					terraform = formatters.lsp,
					typescript = formatters.prettierd,
					typescriptreact = formatters.prettierd,
					yaml = formatters.lsp,

					-- Concatenate formatters
					python = {
						formatters.remove_trailing_whitespace,
						formatters.black,
						formatters.ruff,
					},
					nix = {
						formatters.shell({ cmd = { "alejandra", "-qq" } })
					},
				},

				-- Optional: fallback formatter to use when no formatters match the current filetype
				fallback_formatter = {
					formatters.remove_trailing_whitespace,
					formatters.remove_trailing_newlines,
					formatters.prettierd,
				},

				-- By default, all shell commands are prefixed with "sh -c" (see PR #3)
				-- To prevent that set `run_with_sh` to `false`.
				run_with_sh = false,
			})


			-- Getting formatters needed
			local ensure_installed = {
				"prettierd",
			}
			registry.refresh(function()
				for _, pkg_name in ipairs(ensure_installed) do
					local pkg = registry.get_package(pkg_name)
					if not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end,
	}
}
