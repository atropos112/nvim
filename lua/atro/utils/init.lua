local M = {}

--- @param path string path to directory
--- @param ext string file extensino
M.get_files = function(path, ext)
	local files = {}
	local handle = vim.loop.fs_scandir(path)
	if handle then
		while true do
			local name, t = vim.loop.fs_scandir_next(handle)
			if not name then
				break
			end
			if t == "file" and name:match(ext) then
				table.insert(files, name)
			end
		end
	end
	return files
end

--- @param lst string[]
--- @return string
M.lst_to_str = function(lst)
	local str = ""
	for _, v in ipairs(lst) do
		str = str .. v .. ", "
	end
	return str:sub(1, -3)
end

-- Chceks if a root dir is a git directory
--- @return boolean
M.is_git_dir = function()
	if M._is_git_dir then
		return M._is_git_dir
	end

	local path = vim.fn.getcwd()
	while path do
		if vim.fn.isdirectory(path .. "/.git") == 1 then
			M._is_git_dir = true
			return M._is_git_dir
		end
		path = vim.fn.fnamemodify(path, ":h")
		if path == "/" or path == "" then
			break
		end
	end

	M._is_git_dir = false
	return M._is_git_dir
end

--- @param tbl table<any, string>
--- @return string[]
M.tbl_to_lst = function(tbl, key)
	local lst = {}
	for _, v in pairs(tbl) do
		table.insert(lst, v[key])
	end

	return lst
end

--- @param tbllst table<any, table<any, string>>
--- @param key string
--- @return string
M.tbllst_to_str = function(tbllst, key)
	local str = ""
	for _, v in ipairs(tbllst) do
		str = str .. v[key] .. ", "
	end
	return str:sub(1, -3)
end

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

--- @param path string
--- @return boolean
M.file_exists = function(path)
	-- Expand ~ to the home directory
	if path:sub(1, 1) == "~" then
		path = vim.fn.expand(path)
	end

	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	else
		return false
	end
end

M.dir_exists = function(path)
	-- Expand ~ to the home directory
	if path:sub(1, 1) == "~" then
		path = vim.fn.expand(path)
	end

	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "directory"
end

--- @param t1 table
--- @param t2 table
--- @retun table
M.TableConcat = function(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

--- @param list table<string>
--- @return table<string>
M.Deduplicate = function(list)
	local seen = {}
	local result = {}

	for _, value in ipairs(list) do
		if not seen[value] then
			seen[value] = true
			table.insert(result, value)
		end
	end

	return result
end

--- @return string | nil
M.GetGitRoot = function()
	local handle = io.popen("git rev-parse --show-toplevel")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()
	return result:gsub("%s+", "") -- Trim whitespace
end

return M
