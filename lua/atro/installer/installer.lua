M = {}
local mapper = require("atro.installer.mappings")

---@param ensure_installed string[] | string
---@return nil
M.ensure_installed = function(ensure_installed)
	-- INFO: If ensure_installed is a string, convert it to a table
	if type(ensure_installed) == "string" then
		ensure_installed = { ensure_installed }
	end

	-- INFO: Iterate over the ensure_installed packages and check if they are installed
	local to_install = {}
	for _, name in ipairs(ensure_installed) do
		local bin_name = mapper.to_bin(name)
		local bin_installed = vim.fn.executable(bin_name) == 1
		if not bin_installed then
			table.insert(to_install, name)
		end
	end

	-- INFO: If there are no packages to install, return
	if #to_install == 0 then
		return
	end

	-- WARN: This expects the mason-registry to be installed and available
	local registry = require("mason-registry")

	-- INFO: Refresh the registry and install the packages
	registry.refresh(function()
		for _, pkg_name in ipairs(to_install) do
			local pkg = registry.get_package(mapper.to_mason(pkg_name))

			if not pkg:is_installed() then
				pkg:install()
			end
		end
	end)
end

---@return nil
M.ensure_user_requested_are_installed = function()
	local tableConcat = require("atro.utils.generic").TableConcat
	local deduplicate = require("atro.utils.generic").Deduplicate

	local lsps = require("atro.lsp.configs").lsp_packages()
	local daps = require("atro.dap.configs").dap_packages()
	local linters = require("atro.lint.configs").lint_packages()
	local fmts = require("atro.fmt.configs").fmt_packages()

	local all_packages = {}

	all_packages = tableConcat(all_packages, lsps)
	all_packages = tableConcat(all_packages, daps)
	all_packages = tableConcat(all_packages, linters)
	all_packages = tableConcat(all_packages, fmts)

	all_packages = deduplicate(all_packages)

	M.ensure_installed(all_packages)
end

return M
