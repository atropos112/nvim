local M = {}

---@param directory string A path to a directory of which all lua files are to be loaded
---@return nil
M.load_all_lua_files = function(directory)
	-- Expand ~ to the home directory
	if directory:sub(1, 1) == "~" then
		directory = vim.fn.expand(directory)
	end

	local scandir = vim.loop.fs_scandir
	local fs_scandir_next = vim.loop.fs_scandir_next

	local handle, err = scandir(directory)
	if not handle then
		print("Error scanning directory: " .. err)
		return
	end

	while true do
		local filename, filetype = fs_scandir_next(handle)
		if not filename then
			break
		end

		if filetype == "file" and filename:sub(-4) == ".lua" then
			dofile(directory .. "/" .. filename)
		end
	end
end

return M
