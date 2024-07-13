-- INFO: Can also use :h lspconfig-all to see all available configurations
-- INFO: Below Are per language LSP configurations
local lsp_configs = {
	basedpyright = {
		analysis = {
			autoSearchPaths = true,
			typeCheckingMode = "standard",
			useLibraryCodeForTypes = true,
		},
	},

	pylsp = {
		mason_name = "python-lsp-server",
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

	rnix = {
		mason_name = "rnix-lsp",
	},

	nixd = {
		skip_install = true,
		diagnostic = {
			suppress = { "sema-escaping-with" },
		},
	},

	nil_ls = {
		mason_name = "nil",
	},

	dockerls = {
		mason_name = "dockerfile-language-server",
	},

	zls = {},

	bashls = {
		mason_name = "bash-language-server",
	},

	gopls = {
		gofumpt = true,
		-- NOTE: go plugin take over here so should not pass on_attach.
		skip_on_attach = true,
	},

	jsonls = {
		mason_name = "json-lsp",
	},

	lua_ls = {
		mason_name = "lua-language-server",
	},

	omnisharp = {
		skip_capabilities = true,
	},

	yamlls = {
		skip_install = true,
	},
}
