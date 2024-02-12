return {
	{
		"neovim/nvim-lspconfig",
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
		config = function()
			-- LSP base settings, these will be used throughout the LSP setup
			on_attach = function(_, bufnr)
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

			require("mason").setup()

			-- :h lspconfig-all
			local mason_lsp = require("mason-lspconfig")
			local lsp = require("lspconfig")
			mason_lsp.setup({
				handlers = {
					-- default
					function(server_name)
						require("lspconfig")[server_name].setup({
							on_attach = on_attach,
							capabilities = capabilities,
						})
					end,

					-- handled by csharp.nvim so we don't want default handling
					["omnisharp"] = function()
						require("lspconfig").omnisharp.setup({
							capabilities = capabilities,
						})
					end,
				}
			})
		end,
	},
}
