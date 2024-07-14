local M = {}

-- INFO: Can also use :h lspconfig-all to see all available configurations
-- INFO: Below Are per language LSP configurations
M.lsp_configs = {
	basedpyright = {
		analysis = {
			autoSearchPaths = true,
			typeCheckingMode = "standard",
			useLibraryCodeForTypes = true,
		},
	},

	pylsp = {
		plugins = {
			pycodestyle = {
				ignore = {},
				maxLineLength = 120,
			},
			rope_completion = {
				enabled = true,
			},
			rope_autoimport = {
				enabled = true,
				completions = {
					enabled = true,
				},
				code_actions = {
					enabled = true,
				},
			},
		},
	},

	rnix = {},

	nixd = {
		skip_install = true,
		diagnostic = {
			suppress = { "sema-escaping-with" },
		},
	},

	nil_ls = {},

	dockerls = {},

	zls = {},

	bashls = {},

	gopls = {
		gofumpt = true,
		-- NOTE: go plugin take over here so should not pass on_attach.
		skip_on_attach = true,
	},

	jsonls = {},

	lua_ls = {},

	omnisharp = {
		skip_capabilities = true,
	},

	yamlls = {
	},
}

return M
