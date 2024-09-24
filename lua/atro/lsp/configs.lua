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
M.lsp_configs = function()
	if _G._lsp_configs then
		return _G._lsp_configs
	end

	-- Lazy load the lsp_configs
	if require("atro.utils.generic").file_exists(vim.fn.stdpath("config") .. "/lua/atro/lsp/overrides.lua") then
		_G._lsp_configs = require("atro.lsp.overrides").lsp_configs()
	else
		_G._lsp_configs = {
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

				schemas = require("atro.lsp.yaml_schemas").yaml_schemas(),
			},

			taplo = {},
		}
	end
	return _G._lsp_configs
end

return M
