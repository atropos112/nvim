---@type Keymaps
return require("atro.types.keymaps"):new({
	llm = {
		accept_suggested_change = { "ga", "Accept suggested change", "n" },
		reject_suggested_change = { "gr", "Reject suggested change", "n" },
	},
	comments = {
		generate_annotation = { "<leader>co", "Generate annotation", "nv" },
		-- Below keymaps are a bit "limited" in selection due to how "numToStr/Comment.nvim" works.
		toggle_comment_line = { "gcc", "Toggle comment line", "n" }, -- Only works in normal mode, mode here is ignored
		toggle_comment_block = { "gbc", "Toggle comment block", "n" }, -- Only works in normal mode, mode here is ignored
		operator_pending_line = { "<leader>gc", "Toggle comment line", "v" }, -- Only works in visual mode, mode here is ignored. Keymap must start with <leader>.
		operator_pending_block = { "<leader>gb", "Toggle comment block", "v" }, -- Only works in visual mode, mode here is ignored. Keymap must start with <leader>.
		comment_above = { "gO", "Comment line above", "n" },
		comment_below = { "go", "Comment line below", "n" },
		comment_end_of_line = { "gl", "Comment to end of line", "n" },
	},
	lsp_on_attach = {
		lsp_references = { "gR", "Show LSP references", "nv" },
		lsp_declaration = { "gD", "Go to declaration", "nv" },
		lsp_definitions = { "gd", "Show LSP definitions", "nv" },
		lsp_implementations = { "gi", "Show LSP implementations", "nv" },
		lsp_type_definitions = { "gt", "Show LSP type definitions", "nv" },
		lsp_code_actions = { "<leader>ca", "See available code actions", "nv" },
		lsp_buffer_diagnostics = { "<leader>D", "Show buffer diagnostics", "nv" },
		lsp_line_diagnostics = { "<leader>d", "Show line diagnostics", "nv" },
		lsp_hover = { "K", "Show documentation for what is under cursor", "nv" },
	},
	auto_complete_llm = {
		accept = { "<A-g>", "Accept Copilot suggestion", "i" },
		accept_mac = { "©", "Accept Copilot suggestion (Macbook)", "i" },
	},

	debug = {
		toggle_breakpoint = { "<leader>bb", "Toggle breakpoint", "n" },
		set_conditional_breakpoint = { "<leader>bc", "Set conditional breakpoint", "n" },
	},
	motion = {
		flash_jump = { "s", "Flash jump to next char iteration.", "n" },
		flash_treesitter = { "S", "Flash jump to treesitter points", "n" },
		close_all_goto_previews = { "gP", "Close all goto previews", "nv" },
		open_goto_preview = { "gp", "Open goto preview", "nv" },
		go_to_beginning_of_sub_word = { "W", "Move to beginning of word", "nox" },
		go_to_end_of_sub_word = { "E", "Move to end of word", "nox" },
		go_back_to_previous_sub_word = { "B", "Move back to previous word", "nox" },
	},

	buffer = {
		show_paste_history = { "<leader>pp", "Paste history in telescope", "n" },
		-- The two keys below are only valid inside of the neoclip telescope window (hence no mode)
		insert_from_paste_history = { "<c-p>", "Insert from paste history", "" },
		select_from_paste_history = { "<cr>", "Select from paste history", "" },
	},
	other = {
		show_file_outline = { "<leader>oo", "Show file outline (functions, classes, variables etc)", "n" },
	},
	diagnostic = {
		open_float = { "<leader>of", "Open diagnostic float", "nv" },
	},
	fold = {
		open_fold = { "zo", "Open fold", "nv" },
		close_fold = { "zc", "Close fold", "nv" },
		open_all_folds = { "zR", "Open all folds", "nv" },
		close_all_folds = { "zM", "Close all folds", "nv" },
	},
	text_changing = {
		surround_with = { "ys", "Surround with", "" }, -- Only works in normal mode, no leader key.
		delete_surrounding = { "ds", "Delete surrounding", "" }, -- Only works in normal mode, no leader key.
		change_surrounding = { "cs", "Change surrounding", "" }, -- Only works in normal mode, no leader key.
		rename = { "gy", "Rename", "n" },
	},
	file_exploration = {
		toggle_file_explorer = { "<leader>-", "Toggle file explorer", "n" },
		show_top_bar_keys = { "<leader>e", "Show top bar keys", "n" },
	},
})
