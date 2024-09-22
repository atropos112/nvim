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
			rust = {
				codelldb_path = "~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
				liblldb_path = "~/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so",

				adapters = {
					codelldb = {
						type = "server",
						port = "${port}",
						executable = {
							-- assuming codelldb is in your PATH
							command = "codelldb",
							args = { "--port", "${port}" },
						},
					},
				},

				configs = {
					{
						name = "Debug with codelldb",
						type = "codelldb",
						request = "launch",
						program = function()
							-- we build first
							vim.fn.jobstart("cargo build", {
								on_exit = function(_, code)
									if code == 0 then
										vim.notify("Build successful")
									else
										vim.notify("Build failed")
									end
								end,
							})
							local parent = vim.fn.getcwd()
							-- then we run the program
							return parent .. "/target/debug/" .. vim.fn.fnamemodify(parent, ":t")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
					},
				},
			},
		}
	end

	return _G._dap_configs
end

return M
