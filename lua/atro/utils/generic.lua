local M = {}

---@param mode string|string[] Mode short-name, see |nvim_set_keymap()|.
---@param key string           Left-hand side |{lhs}| of the mapping.
---@param cmd string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts
---@return nil
M.keyset = function(mode, key, cmd, opts)
	opts = opts or {}
	vim.keymap.set(mode, key, cmd, opts)
end

--- @param base table The base table to be (potentially) overridden at root
--- @param override table The table to override the base table at root
--- @return table
---
--- Overrides the elements at root level of the "base" table with the elements from the "override" table.
--- If override does not have the key (at root level) the key from base is used.
M.merge_tables_at_root = function(base, override)
	local result = {}
	for k, v in pairs(base) do
		result[k] = v
	end
	for k, v in pairs(override) do
		result[k] = v
	end
	return result
end

return M
