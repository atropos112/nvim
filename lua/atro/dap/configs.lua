local M = {}

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
			lua = {
				adapters = {
					nlua = function(callback, config)
						callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
					end,
				},
				configs = {
					{
						type = "nlua",
						request = "attach",
						name = "Attach to running Neovim instance",
					},
				},
			},
		}
	end

	return _G._dap_configs
end

return M
