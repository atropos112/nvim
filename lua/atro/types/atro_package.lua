---@meta

---@param name string
---@return string
local name_to_binary = function(name)
	local exceptions = {
		["lua_ls"] = "lua-language-server",
		["jsonls"] = "vscode-json-language-server",
		["yamlls"] = "yaml-language-server",
		["ruff_fix"] = "ruff",
		["ruff_format"] = "ruff",
	}

	return exceptions[name] or name
end

---@param name string
---@return string
local name_to_mason_name = function(name)
	local exceptions = {
		["ruff_fix"] = "ruff",
		["ruff_format"] = "ruff",
		["lua_ls"] = "lua-language-server",
		["pylsp"] = "python-lsp-server", -- its binary is pylsp though.
		["rnix"] = "rnix-lsp",
		["dockerls"] = "dockerfile-language-server",
		["bashls"] = "bash-language-server",
		["jsonls"] = "json-lsp",
		["nil_ls"] = "nil",
		["yamlls"] = "yaml-language-server",
	}

	return exceptions[name] or name
end

---@param name string
---@return boolean
local name_to_skip_install = function(name)
	local exceptions = {
		"zig fmt",
	}

	return vim.list_contains(exceptions, name)
end

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
	self.name = name
	self.bin_name = name_to_binary(name)
	self.mason_name = name_to_mason_name(name)
	self.skip_install = name_to_skip_install(name)

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
