local M = {}

---@param client table
---@param bufnr number
---@return nil
M.on_attach = function(client, bufnr)
	local lsp = vim.lsp

	-- nil can replace with the options of each buffer
	require("inlay-hints").on_attach(client, bufnr)
	require("nvim-navic").attach(client, bufnr)
	-- require("better-diagnostic-virtual-text.api").setup_buf(bufnr, nil) -- WARN: Currently broken.

	lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
		border = "single",
		focusable = false,
		relative = "cursor",
	})

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

---@return table
M.get_capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)
	return capabilities
end

--- This provides a way to streamline LSP loading.
--- The settings can contain the following:
--- skip_on_attach: boolean - if true, will not attach on_attach function
--- skip_capabilities: boolean - if true, will not attach capabilities
--- mason_name: string - the name of the mason package to install if not already installed.
--- If not provided will attempt to install using the lsp name, this only installs if the binary is not found.
--- This is only used if skip_install is not true.
--- skip_install: boolean - if true, will not attempt to install the mason package (regardless if binary exists or not).
---
--- The keys above are removed in the process from the settings table and what is left is passed to the lsp setup function.
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
--- where mason_name is typically not needed but necessary for pylsp as it has a different mason name to its lsp name.
--- here skip_capabilities (and skip_on_attach) is set to false by default and is shown above just for demonsrtation purposes.
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
	local skip_install = settings.skip_install or false
	if not skip_install then
		require("atro.utils.load").install(settings.mason_name or server)
		settings.mason_name = nil
	end

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
	local lsp_configs = require("atro.configs.lsp").lsp_configs
	local lsp = require("lspconfig")
	for _, v in ipairs(require("atro.utils.config").SelectedLSPs()) do
		if lsp_configs[v] then
			lsp = M.setup_lsp(v, lsp_configs[v], lsp)
		else
			error("LSP not configured: " .. v)
		end
	end
end

return M
