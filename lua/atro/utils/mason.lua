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

M.install_fmts = function()
	local fmt_configs = require("atro.configs.user_configs.fmt").fmt_configs
	local is_lang_supported = require("atro.utils.config").IsLangSupported

	for lang, fmts in ipairs(fmt_configs) do
		if is_lang_supported(lang) then
			M.install(fmts)
		end
	end
end

return M
