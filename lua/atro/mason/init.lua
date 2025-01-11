M = {}
local mapper = require("atro.mason.mappings")

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
		if not bin_installed and not mapper.to_skip(name) then
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
M.ensure_packages_are_installed = function()
	local deduplicate = require("atro.utils").Deduplicate

	---@type string[]
	local packages = {}

	for _, cfg in pairs(CONFIG.languages) do
		if cfg.lsps then
			packages = vim.list_extend(packages, vim.tbl_keys(cfg.lsps))
		end

		if cfg.dap_package then
			table.insert(packages, cfg.dap_package)
		end

		if cfg.linters then
			packages = vim.list_extend(packages, cfg.linters)
		end

		if cfg.formatters then
			packages = vim.list_extend(packages, cfg.formatters)
		end
	end

	packages = deduplicate(packages)

	M.ensure_installed(packages)
end

return M
