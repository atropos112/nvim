return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- on-attach will only be executed after our LSP server kicks off
			local on_attach = function(_, bufnr)
				-- a lot of repetition below, making a function and using that instead lowering the cluter a bit.
				local bufmap = function(keys, func)
					vim.keymap.set("n", keys, func, { buffer = bufnr })
				end

				bufmap("<leader>r", vim.lsp.buf.rename)
				bufmap("<leader>a", vim.lsp.buf.code_action)

				bufmap("gd", vim.lsp.buf.definition)
				bufmap("gD", vim.lsp.buf.declaration)
				bufmap("gI", vim.lsp.buf.implementation)
				bufmap("<leader>D", vim.lsp.buf.type_definition)

				bufmap("gr", require("telescope.builtin").lsp_references)

				bufmap("K", vim.lsp.buf.hover)

				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					vim.lsp.buf.format()
				end, {})
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- :h lspconfig-all
			--
			-- mason
			require("mason").setup()
			require("mason-lspconfig").setup_handlers({
				-- default
				function(server_name)
					require("lspconfig")[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,

				-- This is taken over by the csharp.nvim plugin
				["omnisharp"] = function() end,

				["lua_ls"] = function()
					require("neodev").setup()
					require("lspconfig").lua_ls.setup({
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
					require('lspconfig').jsonls.setup {
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							json = {
								schemas = require('schemastore').json.schemas(),
								validate = { enable = true },
							},
						},
					}
				end,

				["yamlls"] = function()
					require('lspconfig').yamlls.setup {
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							yaml = {
								schemaStore = {
									enable = false,
									url = "",
								},
								schemas = require('schemastore').yaml.schemas {
									extra = {
										url = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json',
										name = 'Argo CD Application',
										fileMatch = 'argocd-application.yaml'
									}
								},
							},
						},
					}
				end,
				["pylsp"] = function()
					require('lspconfig').pylsp.setup {
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							pylsp = {
								plugins = {
									-- formatter options
									black = { enabled = true },
									autopep8 = { enabled = false },
									yapf = { enabled = false },
									ruff = { enabled = true },
									-- linter options
									pylint = {
										enabled = true,
										executable = "pylint"
									},
									pyflakes = { enabled = false },
									pycodestyle = {
										enabled = false,
										maxLineLength = 200,
										ignore = {
											"E111", -- indentation is not a multiple of four
											"E121", -- continuation line under-indented for hanging indent
											"W291", -- blank line contains whitespace
											"W293", -- continuation line contains whitespace
										}
									},
									-- type checker
									pylsp_mypy = { enabled = true },
									-- auto-completion options
									jedi_completion = { fuzzy = true },
									-- import sorting
									pyls_isort = {
										enabled = true,
										executable = "isort",
									},
								},
							},
						},
					}
				end,
			})
		end,
	},
	{
		"b0o/schemastore.nvim"
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig"
		},
		opts = {
			ensure_installed = {
				-- Json
				"jsonls",

				-- Markdown
				"marksman",
				"prosemd_lsp",
				"remark_ls",
				"zk",

				-- Bash
				"bashls",

				-- Docker
				"dockerls",
				"docker_compose_language_service",

				-- Helm
				"helm_ls",

				-- Typst
				"typst_lsp",

				-- Yaml
				"yamlls",

				-- Lua
				"lua_ls",

				-- Rust
				"rust_analyzer",

				-- C#
				"omnisharp",

				-- Nix
				"nil_ls",
				"rnix",

				-- Go
				"gopls",
				"golangci_lint_ls",

				-- Python
				"jedi_language_server",
				"pyright",
				"pylsp",
				"pyre",
				"pylyzer",
				"ruff_lsp"
			}
		}
	},
}
