local M = {}

--- INFO: Can also use :h lspconfig-all to see all available configurations
--- INFO: Below Are per language LSP configurations
---
--- For per-LSP config details look here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--- below lsp_config dictionary is used in tandem with the setup_lsp function above which conceals a lot of complexity.
--- Here is an example of usage, suppose your typical lsp setup looks like this:
--- lsp.pylsp.setup({
--- 	on_attach = on_attach,
--- 	capabilities = capabilities,
--- 	settings = {
--- 		pylsp = {
--- 			plugins = {
--- 				pycodestyle = {
--- 					ignore = {},
--- 					maxLineLength = 120,
--- 				},
--- 			},
--- 		},
--- 	},
--- })
--- This would translate to having an entry in lsp_configs blow that looks like:
--- lsp_configs = {
--- 	pylsp = {
--- 		mason_name = "python-lsp-server",
---  	skip_capabilities = false,
--- 		plugins = {
--- 			pycodestyle = {
--- 				ignore = {},
--- 				maxLineLength = 120,
--- 			},
--- 		},
--- 	},
--- }
--- here skip_capabilities (and skip_on_attach) is set to false by default and is shown above just for demonsrtation purposes.
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

	jsonls = {
		server_name = "json",
		schemas = require("schemastore").json.schemas(),
		validate = { enable = true },
	},

	lua_ls = {
		server_name = "Lua",
		telemetry = {
			enabled = false,
		},
		workspace = {
			checkThirdParty = false,
		},
		diagnostics = {
			disable = { "missing-fields" },
		},
	},

	omnisharp = {
		skip_capabilities = true,
	},

	yamlls = {
		server_name = "yaml",
		schemaStore = {
			enable = false, -- using schemastore plugin instead (more functionalities)
			url = "", -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
		},
		schemas = require("schemastore").yaml.schemas({
			extra = {
				{
					name = "Argo Events",
					description = "Argo Events Event Sources and Sensors",
					url = "https://raw.githubusercontent.com/argoproj/argo-events/master/api/jsonschema/schema.json",
					fileMatch = { "*.ae.yaml", "*.ae.yml" },
				},
				{
					name = "Argo Workflow",
					description = "Argo Workflow configuration file",
					url = "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json",
					fileMatch = { "*.awf.yaml", "*.awf.yml" },
				},
			},
		}),
	},
}

return M
