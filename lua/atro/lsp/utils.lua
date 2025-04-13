local M = {}

---@param client table
---@param bufnr number
---@return nil
M.on_attach = function(client, bufnr)
	local telescope = require("telescope.builtin")
	local keys = KEYMAPS.lsp_on_attach

	require("inlay-hints").on_attach(client, bufnr)
	require("virtualtypes").on_attach()
	require("lsp_signature").on_attach(client, bufnr)

	KEYMAPS:set_many({
		{ keys.lsp_references, telescope.lsp_references },
		{ keys.lsp_declaration, vim.lsp.buf.declaration },
		{ keys.lsp_definitions, telescope.lsp_definitions },
		{ keys.lsp_implementations, telescope.lsp_implementations },
		{ keys.lsp_type_definitions, telescope.lsp_type_definitions },
		{ keys.lsp_code_actions, require("actions-preview").code_actions },
		{ keys.lsp_buffer_diagnostics, "<cmd>Telescope diagnostics bufnr=0<CR>" },
		{ keys.lsp_line_diagnostics, vim.diagnostic.open_float },
		{ keys.lsp_hover, vim.lsp.buf.hover },
	}, { noremap = true, silent = true, buffer = bufnr })
end

---@return table
local get_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

	-- nvim-ufo adds these capabilities
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	-- Adding file operations capabilities
	capabilities = vim.tbl_deep_extend("force", capabilities, require("lsp-file-operations").default_capabilities())

	return capabilities
end

---@param server_name string
---@param lsp_config LspConfig
---@param lsp_module any -- The pre-loaded require("lspconfig")
---@return any -- The pre-loaded require("lspconfig") with new server setup
M.setup_lsp = function(server_name, lsp_config, lsp_module)
	local final_cfg = {}

	if lsp_config.skip_on_attach and lsp_config.on_attach then
		error("Cannot skip on_attach and provide an on_attach function")
	end

	if not lsp_config.skip_on_attach then
		if lsp_config.on_attach then
			final_cfg.on_attach = function(client, bufnr)
				M.on_attach(client, bufnr)
				lsp_config.on_attach(client, bufnr)
			end
		else
			final_cfg.on_attach = M.on_attach
		end
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
