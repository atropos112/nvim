if CONFIG.languages["rust"] then
	---@type LazyPlugin[]
	return {
		{
			"mrcjkb/rustaceanvim",
			version = "^5",
			event = { "VeryLazy" }, -- This is when it will really kick-in
			lazy = true, -- Github page says its already lazy loaded and can set lazy to false, but its lazy loaded at startup not for BufRead which is what I wanted
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
			event = { "VeryLazy" },
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
