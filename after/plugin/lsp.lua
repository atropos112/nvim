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
	["omnisharp"] = function()
		require("lspconfig").omnisharp.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			handlers = {
				["textDocument/definition"] = require("omnisharp_extended").handler,
			},
			cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
		})
	end,

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
})
