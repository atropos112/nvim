if CONFIG.languages["rust"] then
	return {
		{
			"mrcjkb/rustaceanvim",
			version = "^5",
			lazy = false,
			ft = { "rust" },
			config = function()
				require("atro.mason").ensure_installed("rust_analyzer")
				-- INFO: Do not need to call require("rustaceanvim") it does it itself (somehow)
				vim.g.rustaceanvim = {
					-- Plugin configuration
					tools = {},
					-- LSP configuration
					server = {
						on_attach = require("atro.lsp.utils").on_attach,
						default_settings = {
							-- rust-analyzer language server configuration
							["rust-analyzer"] = {

								cargo = {
									allFeatures = true,
									loadOutDirsFromCheck = true,
									buildScripts = {
										enable = true,
									},
								},
								checkOnSave = true,
								diagnostics = {
									enable = true,
								},
								procMacro = {
									enable = true,
									ignored = {
										["async-trait"] = { "async_trait" },
										["napi-derive"] = { "napi" },
										["async-recursion"] = { "async_recursion" },
									},
								},
								files = {
									excludeDirs = {
										".direnv",
										".git",
										".github",
										".gitlab",
										"bin",
										"node_modules",
										"target",
										"venv",
										".venv",
									},
								},
							},
						},
					},
					-- DAP configuration
					dap = {},
				}
			end,
		},
		{
			"saecki/crates.nvim",
			tag = "stable",
			event = "BufRead",
			ft = { "toml" },
			opts = {
				completion = {
					crates = {
						enabled = true,
					},
				},
				lsp = {
					enabled = true,
					actions = true,
					completion = true,
					hover = true,
				},
			},
		},
	}
else
	return {}
end
