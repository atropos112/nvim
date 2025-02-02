---@class Keymap
---@field key string
---@field description string
---@field mode string[]

---@class KeyMapWithCmd : Keymap
---@field cmd string|function

---@class OtherKeymaps
---@field show_file_outline Keymap

---@class LspOnAttachKeymaps
---@field lsp_references Keymap
---@field lsp_declaration Keymap
---@field lsp_definitions Keymap
---@field lsp_implementations Keymap
---@field lsp_type_definitions Keymap
---@field lsp_code_actions Keymap
---@field lsp_buffer_diagnostics Keymap
---@field lsp_line_diagnostics Keymap
---@field lsp_prev_diagnostic Keymap
---@field lsp_next_diagnostic Keymap
---@field lsp_hover Keymap

---@class CopilotKeymaps
---@field accept Keymap
---@field accept_mac Keymap

---@class DebugKeymaps
---@field toggle_breakpoint Keymap
---@field set_conditional_breakpoint Keymap
---@field clear_all_breakpoints Keymap

---@class FlashKeymaps
---@field flash_jump Keymap
---@field flash_treesitter Keymap

---@class GoToPreviewsKeymaps
---@field open_goto_preview Keymap
---@field close_all_goto_previews Keymap

---@class WebMotionKeymaps
---@field go_to_beginning_of_word Keymap
---@field go_to_end_of_word Keymap
---@field go_back_to_previous_word Keymap

---@class MotionKeymaps : FlashKeymaps, GoToPreviewsKeymaps, WebMotionKeymaps

---@class NeoClipKeymaps
---@field show_paste_history Keymap
---@field select_from_paste_history Keymap
---@field insert_from_paste_history Keymap

---@class BufferKeymaps : NeoClipKeymaps

---@class DiagnosticKeymaps
---@field open_float Keymap

---@class CommentKeymaps
---@field generate_annotation Keymap
---@field toggle_comment_line Keymap
---@field toggle_comment_block Keymap
---@field comment_above Keymap
---@field comment_below Keymap
---@field comment_end_of_line Keymap
---@field operator_pending_line Keymap
---@field operator_pending_block Keymap

---@class FoldKeymaps
---@field open_fold Keymap
---@field close_fold Keymap
---@field open_all_folds Keymap
---@field close_all_folds Keymap

---@class Keymaps
---@field other OtherKeymaps
---@field lsp_on_attach LspOnAttachKeymaps
---@field copilot CopilotKeymaps
---@field debug DebugKeymaps
---@field motion MotionKeymaps
---@field buffer BufferKeymaps
---@field diagnostic DiagnosticKeymaps
---@field comments CommentKeymaps
---@field fold FoldKeymaps
local Keymaps = {}
Keymaps.__index = Keymaps

---@param opts? vim.keymap.set.Opts
---@param keysWithCmd table
---@return nil
function Keymaps:set_many(keysWithCmd, opts)
	if opts == nil then
		opts = { noremap = true, silent = true }
	end

	---@type KeyMapWithCmd[]
	local key_maps_with_cmd = {}

	for _, key in ipairs(keysWithCmd) do
		if type(key) ~= "table" then
			error("Invalid key: " .. tostring(key))
		end

		if #key ~= 2 then
			error("Expected a keymap and cmd (table of 2 elements), got: " .. vim.inspect(key))
		end

		---@type Keymap
		local keymap = key[1]

		if keymap == nil then
			error("Keymap is required, got: " .. vim.inspect(key))
		end

		---@type string|function
		local cmd = key[2]

		if cmd == nil then
			error("Command is required, got: " .. vim.inspect(key))
		end

		table.insert(key_maps_with_cmd, { key = keymap.key, mode = keymap.mode, description = keymap.description, cmd = cmd })
	end

	---@type vim.keymap.set.Opts
	local new_opts = vim.deepcopy(opts)

	for _, key in ipairs(key_maps_with_cmd) do
		new_opts.desc = key.description

		if key.cmd == nil then
			error("Command is required, got: " .. vim.inspect(key))
		end

		if key.key == nil then
			error("Key is required, got: " .. vim.inspect(key))
		end

		if key.mode == nil then
			error("Mode is required, got: " .. vim.inspect(key))
		end

		vim.keymap.set(key.mode, key.key, key.cmd, new_opts)
	end
end

---@param mode string | string[]
---@return string[]
local parse_mode = function(mode)
	if type(mode) == "string" then
		local result = {}
		for i = 1, #mode do
			result[i] = mode:sub(i, i)
		end
		return result
	end

	return mode
end

---@param keymap Keymap | table
---@return Keymap
local parse_keymap = function(keymap)
	if keymap.key and keymap.description and keymap.mode then
		keymap.mode = parse_mode(keymap.mode)
		return keymap
	end

	if type(keymap) ~= "table" then
		error("Invalid keymap: " .. vim.inspect(keymap))
	end

	if #keymap ~= 3 then
		error("Expected a keymap (table of 3 elements), got: " .. vim.inspect(keymap))
	end

	---@type Keymap
	return {
		key = keymap[1],
		description = keymap[2],
		mode = parse_mode(keymap[3]),
	}
end

---@param key Keymap | table
---@param error_on_missing? boolean
---@return string
function Keymaps:key_without_leader(key, error_on_missing)
	if error_on_missing == nil then
		error_on_missing = true
	end

	key = parse_keymap(key)
	-- Fetch first <leader> part of the key and see if equal to <leader>
	local maybe_leader = key.key:sub(1, 8)

	if maybe_leader == "<leader>" then
		return key.key:sub(9)
	end

	if error_on_missing then
		error("Keymap does not start with <leader>: " .. key.key)
	end

	return key.key
end

---@param key Keymap | table
---@param cmd string|function
---@param opts? vim.keymap.set.Opts
function Keymaps:set(key, cmd, opts)
	key = parse_keymap(key)

	if opts == nil then
		opts = { noremap = true, silent = true }
	end

	local new_opts = vim.deepcopy(opts)
	new_opts.desc = key.description

	vim.keymap.set(parse_mode(key.mode), key.key, cmd, new_opts)
end

---@param key string Key to map to (e.g. "<leader>pv")
---@param description string Description of the keymap
---@param mode string|string[] Mode short-name, see |nvim_set_keymap()|.
---@return Keymap
function Keymaps:make(key, description, mode)
	if not description then
		error("Description is required")
	end

	if not key then
		error("Key is required")
	end

	if not mode then
		mode = { "n" }
	end

	if type(mode) == "string" then
		mode = { mode }
	end

	---@type Keymap
	return {
		key = key,
		description = description,
		mode = mode,
	}
end

---@param keymaps Keymaps
---@return Keymaps
function Keymaps:new(keymaps)
	for section_name, section in pairs(keymaps) do
		for keymap_name, keymap in pairs(section) do
			keymaps[section_name][keymap_name] = parse_keymap(keymap)
		end
	end

	local o = keymaps or {} -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

return Keymaps
