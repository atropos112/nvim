---@meta

---@class AtroPackage
---@field name string The name used by non-mason tools
---@field bin_name string The name of the corresponding binary that will appear in the path when installed
---@field mason_name string The name of the package in the mason registry
local AtroPackage = {}
AtroPackage.__index = AtroPackage

-- Constructor
---@param name string
---@return AtroPackage
function AtroPackage:new(name)
	local binary_name_exceptions = {
		["csharp-language-server"] = "csharp-ls",
		["python-lsp-server"] = "pylsp",
		["docker-compose-language-service"] = "docker-compose-langserver",
		["lua_ls"] = "lua-language-server",
	}

	local mason_name_exceptions = {
		["ruff_fix"] = "ruff",
		["ruff_format"] = "ruff",
		["lua_ls"] = "lua-language-server",
	}

	local skip_install_exceptions = {
		["zig fmt"] = true,
	}

	self.name = name
	self.bin_name = binary_name_exceptions[name] or name
	self.mason_name = mason_name_exceptions[name] or name
	self.skip_install = skip_install_exceptions[name] or false

	return self
end

---@return boolean
function AtroPackage:bin_exists()
	return vim.fn.executable(self.bin_name) == 1
end

---@param registry any The registry that comes from the mason package
function AtroPackage:install(registry)
	if self.skip_install then
		return
	end

	if not self:bin_exists() then
		local pkg = registry.get_package(self.mason_name)
		if not pkg:is_installed() then
			pkg:install()
		end
	end
end

return AtroPackage
