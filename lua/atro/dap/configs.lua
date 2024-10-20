local M = {}

-- INFO: This is not as built out and user configurable as LSPs because its much simpler in nature, no need to bother.
--
--- @return string[]
M.dap_packages = function()
	local dap_packages = {}
	local IsLangSupported = require("atro.utils.config").IsLangSupported

	if IsLangSupported("python") then
		dap_packages[#dap_packages + 1] = "debugpy"
	end
	if IsLangSupported("cs") then
		dap_packages[#dap_packages + 1] = "netcoredbg"
	end
	if IsLangSupported("go") then
		dap_packages[#dap_packages + 1] = "dlv"
	end

	return dap_packages
end

M.dap_configs = function()
	if _G._dap_configs then
		return _G._dap_configs
	end

	-- Lazy eval
	if require("atro.utils.generic").file_exists(vim.fn.stdpath("config") .. "/lua/atro/dap/overrides.lua") then
		_G._dap_configs = require("atro.dap.overrides").dap_configs()
	else
		-- INFO: Each debug config comes with a config and an adapter section.
		-- However sometimes instead of providing these directly a plugin sets this up.
		-- In that case the configs below will be missing the adapter and config sections.
		_G._dap_configs = {
			python = {
				debugpy_python_path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
			},
			rust = {}, -- Entirely handled by rustacean.nvim plugin
			cs = {
				adapters = {
					netcoredbg = {
						type = "executable",
						command = "netcoredbg",
						args = { "--interpreter=vscode" },
					},
				},

				configs = {
					{
						type = "netcoredbg",
						name = "launch - netcoredbg",
						request = "launch",
						program = function()
							---@diagnostic disable-next-line
							return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
						end,
					},
				},
			},
		}
	end

	return _G._dap_configs
end

return M
