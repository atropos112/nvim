local M = {}

M.install_package = function(pip_path, package)
	-- Construct the pip command to list installed packages
	local list_command = pip_path .. " list"

	-- Execute the command to get the list of installed packages
	local installed_packages = vim.fn.system(list_command)

	-- Search for the package in the list of installed packages
	if not string.find(installed_packages, package) then
		-- If the package is not found, construct the command to install it
		local install_command = pip_path .. " install " .. package

		-- Execute the installation command silently
		vim.fn.system(install_command)

		-- Error handling can be adjusted based on whether you want silent operation or some logging
		if vim.v.shell_error ~= 0 then
			print("Error installing package: " .. package)
		end
	end
	-- If the package is already installed, do nothing (silently continue)
end

return M
