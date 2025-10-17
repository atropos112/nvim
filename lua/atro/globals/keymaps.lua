---@class Keymap
---@field key string
---@field description string
---@field mode string[]

---@param key string
---@param desc string
---@param mode string | string[]
---@return Keymap
local key = function(key, desc, mode)
	local new_mode = {}
	if type(mode) == "string" then
		for i = 1, #mode do
			new_mode[i] = mode:sub(i, i)
		end
	else
		new_mode = mode
	end

	---@type Keymap
	return {
		key = key,
		description = desc,
		mode = new_mode,
	}
end

local Keymaps = {
	llm = {
		accept_suggested_change = key("ga", "Accept suggested change", "n"),
		reject_suggested_change = key("gr", "Reject suggested change", "n"),
	},

	comments = {
		generate_annotation = key("<leader>co", "Generate annotation", "nv"),
		toggle_comment_line = key("gcc", "Toggle comment line", "n"), -- Only works in normal mode, mode here is ignored
		toggle_comment_block = key("gbc", "Toggle comment block", "n"), -- Only works in normal mode, mode here is ignored
		operator_pending_line = key("<leader>gc", "Toggle comment line", "v"), -- Only works in visual mode, mode here is ignored. Keymap must start with <leader>.
		operator_pending_block = key("<leader>gb", "Toggle comment block", "v"), -- Only works in visual mode, mode here is ignored. Keymap must start with <leader>.
		comment_above = key("gO", "Comment line above", "n"),
		comment_below = key("go", "Comment line below", "n"),
		comment_end_of_line = key("gl", "Comment to end of line", "n"),
	},

	lsp_on_attach = {
		lsp_references = key("gR", "Show LSP references", "nv"),
		lsp_declaration = key("gD", "Go to declaration", "nv"),
		lsp_definitions = key("gd", "Show LSP definitions", "nv"),
		lsp_implementations = key("gi", "Show LSP implementations", "nv"),
		lsp_type_definitions = key("gt", "Show LSP type definitions", "nv"),
		lsp_code_actions = key("<leader>ca", "See available code actions", "nv"),
		lsp_buffer_diagnostics = key("<leader>D", "Show buffer diagnostics", "nv"),
		lsp_line_diagnostics = key("<leader>tc", "Show line diagnostics", "nv"),
		lsp_prev_diagnostic = key("[d", "Go to previous diagnostic", "nv"),
		lsp_next_diagnostic = key("]d", "Go to next diagnostic", "nv"),
		lsp_hover = key("K", "Show documentation for what is under cursor", "nv"),
	},

	auto_complete_llm = {
		accept = key("<A-g>", "Accept Copilot suggestion", "i"),
		accept_mac = key("©", "Accept Copilot suggestion (Macbook)", "i"),
	},

	debug = {
		toggle_breakpoint = key("<leader>db", "toggle [d]ebug [b]reakpoint", "n"),
		set_breakpoint = key("<leader>dB", "set [d]ebug [B]reakpoint", "n"),
		continue = key("<leader>dc", "[d]ebug [c]ontinue (start here)", "n"),
		run_to_cursor = key("<leader>dC", "[d]ebug [C]ursor", "nv"),
		goto_line = key("<leader>dg", "[d]ebug [g]o to line", "nv"),
		step_over = key("<leader>do", "[d]ebug step [o]ver", "nv"),
		step_out = key("<leader>dO", "[d]ebug step [O]ut", "nv"),
		step_into = key("<leader>di", "[d]ebug [i]nto", "nv"),
		down = key("<leader>dj", "[d]ebug [j]ump down", "nv"),
		up = key("<leader>dk", "[d]ebug [k]ump up", "nv"),
		run_last = key("<leader>dl", "[d]ebug [l]ast", "nv"),
		pause = key("<leader>dp", "[d]ebug [p]ause", "nv"),
		repl_toggle = key("<leader>dr", "[d]ebug [r]epl", "nv"),
		clear_breakpoints = key("<leader>dR", "[d]ebug [R]emove breakpoints", "nv"),
		session = key("<leader>ds", "[d]ebug [s]ession", "nv"),
		terminate = key("<leader>dt", "[d]ebug [t]erminate", "nv"),
		hover_widgets = key("<leader>dw", "[d]ebug [w]idgets", "nv"),
	},

	testing = {
		attach = key("<leader>ta", "[t]est [a]ttach", "n"),
		run_file = key("<leader>tf", "[t]est run [f]ile", "n"),
		run_all_files = key("<leader>tA", "[t]est [A]ll files", "n"),
		run_suite = key("<leader>tS", "[t]est [S]uite", "n"),
		run_nearest = key("<leader>tn", "[t]est [n]earest", "n"),
		run_last = key("<leader>tl", "[t]est [l]ast", "n"),
		toggle_summary = key("<leader>ts", "[t]est [s]ummary", "n"),
		open_output = key("<leader>to", "[t]est [o]utput", "n"),
		toggle_output_panel = key("<leader>tO", "[t]est [O]utput panel", "n"),
		stop = key("<leader>tt", "[t]est [t]erminate", "n"),
		debug_nearest = key("<leader>td", "Debug nearest test", "n"),
		debug_file = key("<leader>tD", "Debug current file", "n"),
	},

	motion = {
		flash_jump = key("s", "Flash jump to next char iteration.", "n"),
		flash_treesitter = key("S", "Flash jump to treesitter points", "n"),
		close_all_goto_previews = key("gP", "Close all goto previews", "nv"),
		open_goto_preview = key("gp", "Open goto preview", "nv"),
		go_to_beginning_of_sub_word = key("W", "Move to beginning of word", "nox"),
		go_to_end_of_sub_word = key("E", "Move to end of word", "nox"),
		go_back_to_previous_sub_word = key("B", "Move back to previous word", "nox"),
	},

	buffer = {
		show_paste_history = key("<leader>pp", "Paste history in telescope", "n"),
		-- The two keys below are only valid inside of the neoclip telescope window (hence no mode)
		insert_from_paste_history = key("<c-p>", "Insert from paste history", ""),
		select_from_paste_history = key("<cr>", "Select from paste history", ""),
	},

	other = {
		show_file_outline = key("<leader>oo", "Show file outline (functions, classes, variables etc)", "n"),
	},

	diagnostic = {
		open_float = key("<leader>of", "Open diagnostic float", "nv"),
	},

	fold = {
		open_fold = key("zo", "Open fold", "nv"),
		close_fold = key("zc", "Close fold", "nv"),
		open_all_folds = key("zR", "Open all folds", "nv"),
		close_all_folds = key("zM", "Close all folds", "nv"),
	},

	text_changing = {
		surround_with = key("ys", "Surround with", "n"), -- Only works in normal mode, no leader key.
		delete_surrounding = key("ds", "Delete surrounding", "n"), -- Only works in normal mode, no leader key.
		change_surrounding = key("cs", "Change surrounding", "n"), -- Only works in normal mode, no leader key.
		rename = key("gy", "Rename", "n"),
	},

	file_exploration = {
		toggle_file_explorer = key("<leader>-", "Toggle file explorer", "n"),
		show_top_bar_keys = key("<leader>e", "Show top bar keys", "n"),
	},
}

---@class KeyMapWithCmd : Keymap
---@field cmd string|function

---@param opts? vim.keymap.set.Opts
---@param keysWithCmd table
---@return nil
function Keymaps:set_many(keysWithCmd, opts)
	if opts == nil then
		opts = { noremap = true, silent = true }
	end

	---@type KeyMapWithCmd[]
	local key_maps_with_cmd = {}

	for _, ky in ipairs(keysWithCmd) do
		if type(ky) ~= "table" then
			error("Invalid key: " .. tostring(ky))
		end

		if #ky ~= 2 then
			error("Expected a keymap and cmd (table of 2 elements), got: " .. vim.inspect(ky))
		end

		---@type Keymap
		local keymap = ky[1]

		if keymap == nil then
			error("Keymap is required, got: " .. vim.inspect(ky))
		end

		---@type string|function
		local cmd = ky[2]

		if cmd == nil then
			error("Command is required, got: " .. vim.inspect(ky))
		end

		table.insert(key_maps_with_cmd, { key = keymap.key, mode = keymap.mode, description = keymap.description, cmd = cmd })
	end

	---@type vim.keymap.set.Opts
	local new_opts = vim.deepcopy(opts)

	for _, ky in ipairs(key_maps_with_cmd) do
		new_opts.desc = ky.description

		if ky.cmd == nil then
			error("Command is required, got: " .. vim.inspect(ky))
		end

		if ky.key == nil then
			error("Key is required, got: " .. vim.inspect(ky))
		end

		if ky.mode == nil then
			error("Mode is required, got: " .. vim.inspect(ky))
		end

		vim.keymap.set(ky.mode, ky.key, ky.cmd, new_opts)
	end
end

---@param keymap Keymap | table
---@return Keymap
local parse_keymap = function(keymap)
	if keymap.key and keymap.description and keymap.mode then
		return key(keymap.key, keymap.description, keymap.mode)
	end

	if type(keymap) ~= "table" then
		error("Invalid keymap: " .. vim.inspect(keymap))
	end

	if #keymap ~= 3 then
		error("Expected a keymap (table of 3 elements), got: " .. vim.inspect(keymap))
	end

	---@type Keymap
	return key(keymap[1], keymap[2], keymap[3])
end

---@param keymap Keymap | table
---@param error_on_missing? boolean
---@return string
function Keymaps:key_without_leader(keymap, error_on_missing)
	if error_on_missing == nil then
		error_on_missing = true
	end

	keymap = parse_keymap(keymap)
	-- Fetch first <leader> part of the key and see if equal to <leader>
	local maybe_leader = keymap.key:sub(1, 8)

	if maybe_leader == "<leader>" then
		return keymap.key:sub(9)
	end

	if error_on_missing then
		error("Keymap does not start with <leader>: " .. keymap.key)
	end

	return keymap.key
end

---@param keymap Keymap | table
---@param cmd string|function
---@param opts? vim.keymap.set.Opts
function Keymaps:set(keymap, cmd, opts)
	keymap = parse_keymap(keymap)

	if opts == nil then
		opts = { noremap = true, silent = true }
	end

	local new_opts = vim.deepcopy(opts)
	new_opts.desc = keymap.description

	vim.keymap.set(keymap.mode, keymap.key, cmd, new_opts)
end

return Keymaps
