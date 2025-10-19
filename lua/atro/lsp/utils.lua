local M = {}

---@param client table
---@param bufnr number
---@return nil
M.on_attach = function(client, bufnr)
	local telescope = require("telescope.builtin")
	local keys = KEYMAPS.lsp_on_attach

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

	--nvim-ufo adds these capabilities
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	-- Adding file operations capabilities
	capabilities = vim.tbl_deep_extend("force", capabilities, require("lsp-file-operations").default_capabilities())

	return capabilities
end

---@param user_lsp_config LspConfig
---@return table
M.parse_user_lsp_config = function(user_lsp_config)
	local final_cfg = {}

	if user_lsp_config.skip_on_attach and user_lsp_config.on_attach then
		error("Cannot skip on_attach and provide an on_attach function")
	end

	if not user_lsp_config.skip_on_attach then
		if user_lsp_config.on_attach then
			final_cfg.on_attach = function(client, bufnr)
				M.on_attach(client, bufnr)
				user_lsp_config.on_attach(client, bufnr)
			end
		else
			final_cfg.on_attach = M.on_attach
		end
	end

	if not user_lsp_config.skip_capabilities then
		final_cfg.capabilities = get_capabilities()
	end

	if user_lsp_config.settings then
		if type(user_lsp_config.settings) == "function" then
			final_cfg.settings = user_lsp_config.settings()
		else
			final_cfg.settings = user_lsp_config.settings
		end
	end

	return final_cfg
end

return M
