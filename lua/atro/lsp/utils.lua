local M = {}

---@param client table
---@param bufnr number
---@return nil
local on_attach = function(client, bufnr)
	local telescope = require("telescope.builtin")

	require("inlay-hints").on_attach(client, bufnr)

	-- Only attach navic to one LSP client if it supports documentSymbolProvider
	if client.server_capabilities.documentSymbolProvider and not (vim.b[bufnr].navic_client_id ~= nil and vim.b[bufnr].navic_client_name ~= client.name) then
		require("nvim-navic").attach(client, bufnr)
	end

	require("virtualtypes").on_attach()

	local set_keys = require("atro.utils").keysets

	set_keys({ "n", "v" }, { noremap = true, silent = true, buffer = bufnr }, {
		{ "gR", telescope.lsp_references, "Show LSP references" },
		{ "gD", vim.lsp.buf.declaration, "Go to declaration" },
		{ "gy", vim.lsp.buf.rename, "Rename" },
		{ "gd", telescope.lsp_definitions, "Show LSP definitions" },
		{ "gi", telescope.lsp_implementations, "Show LSP implementations" },
		{ "gt", telescope.lsp_type_definitions, "Show LSP type definitions" },
		{ "<leader>ca", vim.lsp.buf.code_action, "See available code actions" },
		{ "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
		{ "<leader>d", vim.diagnostic.open_float, "Show line diagnostics" },
		{ "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic" },
		{ "]d", vim.diagnostic.goto_next, "Go to next diagnostic" },
		{ "K", vim.lsp.buf.hover, "Show documentation for what is under cursor" },
	})
end

---@return table
local get_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	return capabilities
end

---@param server_name string
---@param lsp_config LspConfig
---@param lsp_module any -- The pre-loaded require("lspconfig")
---@return any -- The pre-loaded require("lspconfig") with new server setup
M.setup_lsp = function(server_name, lsp_config, lsp_module)
	local final_cfg = {}

	if not lsp_config.skip_on_attach then
		final_cfg.on_attach = on_attach
	end

	if not lsp_config.skip_capabilities then
		final_cfg.capabilities = get_capabilities()
	end

	if lsp_config.settings then
		if type(lsp_config.settings) == "function" then
			final_cfg.settings = lsp_config.settings()
		else
			final_cfg.settings = lsp_config.settings
		end
	end

	lsp_module[server_name].setup(final_cfg)

	return lsp_module
end

return M
