local M = {}

---@return nil
function M.load_defaults()
	local set = vim.keymap.set

	set("n", "<leader>pv", vim.cmd.Ex)

	-- move selected line / block of text in visual mode
	-- :m here is the move command set("v", "J", ":m '>+1<CR>gv=gv")
	set("v", "K", ":m '<-2<CR>gv=gv")

	-- half page jumping and keeping in the same position on the screen
	set("n", "<C-d>", "<C-d>zz")
	set("n", "<C-u>", "<C-u>zz")

	-- paste foo over bar and then keep foo in registry rather than bar
	set("x", "<leader>p", [["_dP]])

	-- chmod +x current file
	set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

	-- Save with Ctrl + s, in all modes
	set({ "i", "v", "n" }, "<C-s>", "<cmd>w<CR>")

	set("n", "<leader>of", function()
		vim.diagnostic.open_float()
	end, { desc = "Diagnostic float" })

	-- move lines up and down by 5 lines up and down
	set({ "n", "v" }, "<C-j>", "7jzz")
	set({ "n", "v" }, "<C-k>", "7kzz")

	-- :tnoremap <Esc> <C-\><C-n>
	-- Allowing escaping in terminal mode
	set("t", "<Esc>", "<C-\\><C-n>")
end

M.load_defaults()

---@type Keymaps
return require("atro.types.keymaps"):new({
	lsp_on_attach = {
		lsp_references = { "gR", "Show LSP references", "nv" },
		lsp_declaration = { "gD", "Go to declaration", "nv" },
		lsp_definitions = { "gd", "Show LSP definitions", "nv" },
		lsp_implementations = { "gi", "Show LSP implementations", "nv" },
		lsp_type_definitions = { "gt", "Show LSP type definitions", "nv" },
		lsp_code_actions = { "<leader>ca", "See available code actions", "nv" },
		lsp_buffer_diagnostics = { "<leader>D", "Show buffer diagnostics", "nv" },
		lsp_line_diagnostics = { "<leader>d", "Show line diagnostics", "nv" },
		lsp_prev_diagnostic = { "[d", "Go to previous diagnostic", "nv" },
		lsp_next_diagnostic = { "]d", "Go to next diagnostic", "nv" },
		lsp_hover = { "K", "Show documentation for what is under cursor", "nv" },
	},
	copilot = {
		accept = { "<A-g>", "Accept Copilot suggestion", "i" },
		accept_mac = { "©", "Accept Copilot suggestion (Macbook)", "i" },
	},

	debug = {
		toggle_breakpoint = { "<leader>bb", "Toggle breakpoint", "n" },
		set_conditional_breakpoint = { "<leader>bc", "Set conditional breakpoint", "n" },
	},
	position = {
		flash_jump = { "s", "Flash jump to next char iteration.", "nxo" },
		flash_treesitter = { "S", "Flash jump to treesitter points", "nxo" },
	},

	buffer = {
		show_paste_history = { "<leader>pp", "Paste history in telescope", "n" },
		-- The two keys below are only valid inside of the neoclip telescope window (hence no mode)
		insert_from_paste_history = { "<c-p>", "Insert from paste history", "" },
		select_from_paste_history = { "<cr>", "Select from paste history", "" },
	},
})
