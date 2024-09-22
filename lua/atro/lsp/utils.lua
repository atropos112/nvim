local M = {}
local lsp_configs = require("atro.lsp.configs").lsp_configs

---@param client table
---@param bufnr number
---@return nil
M.on_attach = function(client, bufnr)
	require("inlay-hints").on_attach(client, bufnr)

	-- WARN: Python is a very special case. I have two LSPs there and basedpyright's go to def doesn't always work.
	-- So turning it off, only relying on pylsp's go to definition.
	-- Adjust capabilities based on the LSP client
	if client.name == "basedpyright" then
		-- Disable GoToDefinition for basedpyright
		client.server_capabilities.definitionProvider = false
	elseif client.name == "pylsp" then
		-- Ensure GoToDefinition is enabled for pylsp
		client.server_capabilities.definitionProvider = true
	end

	-- Only attach navic to one LSP client if it supports documentSymbolProvider
	if client.server_capabilities.documentSymbolProvider and not (vim.b[bufnr].navic_client_id ~= nil and vim.b[bufnr].navic_client_name ~= client.name) then
		require("nvim-navic").attach(client, bufnr)
	end

	local opts = { noremap = true, silent = true }
	opts.buffer = bufnr
	local set = require("atro.utils.generic").keyset

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
M.get_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	return capabilities
end

--- This provides a way to streamline LSP loading.
--- The settings can contain the following:
--- skip_on_attach: boolean - if true, will not attach on_attach function
--- skip_capabilities: boolean - if true, will not attach capabilities
--- If not provided will attempt to install using the lsp name, this only installs if the binary is not found.
--- This is only used if skip_install is not true.
--- skip_install: boolean - if true, will not attempt to install the mason package (regardless if binary exists or not).
---
--- The keys above are removed in the process from the settings table and what is left is passed to the lsp setup function.
---
---@param server string
---@param settings table
---@param lsp table
---@return table
M.setup_lsp = function(server, settings, lsp)
	settings = settings or {}

	-- skip's
	local skip_on_attach = settings.skip_on_attach or false
	settings.skip_on_attach = nil -- remove the key

	local skip_capabilities = settings.skip_capabilities or false
	settings.skip_capabilities = nil

	-- mason install
	if not settings.skip_install then
		require("atro.utils.load").install(server)
	end
	settings.skip_install = nil

	-- Alternative server name (optional)
	local server_name = settings.server_name or server
	settings.server_name = nil

	-- create lsp settings
	local lsp_settings = {
		settings = {},
	}

	-- By now settings should only have the LSP specific settings not any special keys of mine.
	lsp_settings.settings[server_name] = settings or {}

	if not skip_on_attach then
		lsp_settings.on_attach = settings.on_attach or M.on_attach
	end

	if not skip_capabilities then
		lsp_settings.capabilities = settings.capabilities or M.get_capabilities()
	end

	lsp[server].setup(lsp_settings)

	return lsp
end

M.setup_lsps = function()
	local lsp = require("lspconfig")
	for _, v in ipairs(require("atro.utils.config").SelectedLSPs()) do
		if lsp_configs()[v] then
			lsp = M.setup_lsp(v, lsp_configs()[v], lsp)
		else
			error("LSP not configured: " .. v)
		end
	end
end

return M
