return {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"jubnzv/virtual-types.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			-- INFO: Defining On_Attach
			local on_attach = function(_, bufnr)
				local set = require("atro.utils.generic").keyset

				local opts = { noremap = true, silent = true }
				opts.buffer = bufnr

				-- set keybinds
				opts.desc = "Show LSP references"
				set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
				require("virtualtypes").on_attach()
			end

			-- INFO: Defining Capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- INFO: Defining LSP Config
			require("mason").setup()
			local lsp = require("lspconfig")
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"jsonls",
					"pyright",
					"yamlls",
					"dockerls",
					"docker_compose_language_service",
					"nil_ls",
					"rnix",
					"bashls",
					"typst_lsp",
					"rust_analyzer",
				},
				-- NOTE: For per-LSP config details look here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
				handlers = {
					function(server_name)
						lsp[server_name].setup({
							on_attach = on_attach,
							capabilities = capabilities,
						})
					end,

					-- INFO: Is covered partialy be the csharp plugin (look at csharp specific config file for details)
					["omnisharp"] = function()
						lsp.omnisharp.setup({
							on_attach = on_attach,
						})
					end,

					["gopls"] = function()
						-- NOTE: go plugin take over here so should not pass capabilities or on_attach.
						lsp.gopls.setup({
							capabilities = capabilities,
						})
					end,

					["lua_ls"] = function()
						require("neodev").setup()
						lsp.lua_ls.setup({
							on_attach = on_attach,
							capabilities = capabilities,
							settings = {
								Lua = {
									workspace = { checkThirdParty = false },
									telemetry = { enable = false },
								},
							},
						})
					end,

					["jsonls"] = function()
						lsp.jsonls.setup({
							on_attach = on_attach,
							capabilities = capabilities,
							settings = {
								json = {
									schemas = require("schemastore").json.schemas(),
									validate = { enable = true },
								},
							},
						})
					end,

					["yamlls"] = function()
						lsp.yamlls.setup({
							on_attach = on_attach,
							capabilities = capabilities,
							settings = {
								yaml = {
									schemaStore = {
										enable = false,
										url = "",
									},
									schemas = require("schemastore").yaml.schemas({
										extra = {
											url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
											name = "Argo CD Application",
											fileMatch = "argocd-application.yaml",
										},
									}),
								},
							},
						})
					end,
				},
			})
		end,
	},
}
