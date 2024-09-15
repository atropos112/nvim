local M = {}

---@type AtroPackage
AtroPackage = require("atro.types.atro_package")

---Install a package if it is not already installed
---@param ensure_installed string[] | string
---@return nil
M.install = function(ensure_installed)
	-- Allow for passing in a single string
	if type(ensure_installed) == "string" then
		ensure_installed = { ensure_installed }
	end

	local registry = require("mason-registry")
	registry.refresh(function()
		for _, pkg_name in ipairs(ensure_installed) do
			AtroPackage:new(pkg_name):install(registry)
		end
	end)
end

---@param configs_table table
---@return nil
M.install_from_configs_table = function(configs_table)
	local is_lang_supported = require("atro.utils.config").IsLangSupported

	for lang, item in pairs(configs_table) do
		if is_lang_supported(lang) then
			M.install(item)
		end
	end
end

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
