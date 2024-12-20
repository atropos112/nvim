local M = {}

---@param client table
---@param bufnr number
---@return nil
local on_attach = function(client, bufnr)
	require("inlay-hints").on_attach(client, bufnr)

	-- Only attach navic to one LSP client if it supports documentSymbolProvider
	if client.server_capabilities.documentSymbolProvider and not (vim.b[bufnr].navic_client_id ~= nil and vim.b[bufnr].navic_client_name ~= client.name) then
		require("nvim-navic").attach(client, bufnr)
	end

	local opts = { noremap = true, silent = true }
	opts.buffer = bufnr
	local set = require("atro.utils").keyset

	-- set keybinds
	opts.desc = "Show LSP references"
	set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

	opts.desc = "Go to declaration"
	set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

	set("n", "gy", vim.lsp.buf.rename, opts) -- rename

	opts.desc = "Show LSP definitions"
	set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

	opts.desc = "Show LSP implementations"
	set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

	opts.desc = "Show LSP type definitions"
	set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

	opts.desc = "See available code actions"
	set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

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

	require("virtualtypes").on_attach()
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
