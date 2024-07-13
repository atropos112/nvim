if require("atro.utils.config").IsLangSupported("c_sharp") then
	return {
		{
			"iabdelkareem/csharp.nvim",
			dependencies = {
				"williamboman/mason.nvim", -- Required, automatically installs omnisharp
				"mfussenegger/nvim-dap",
				"Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
			},
			ft = "cs",
			config = function()
				-- NOTE: Dependency sourcing
				require("atro.utils.load").install({
					-- debugger
					"netcoredbg",
				})

				-- NOTE: Debugger
				local dap = require("dap")
				dap.adapters.netcoredbg = {
					type = "executable",
					command = "netcoredbg",
					args = { "--interpreter=vscode" },
				}

				dap.configurations.cs = {
					{
						type = "netcoredbg",
						name = "launch - netcoredbg",
						request = "launch",
						program = function()
							---@diagnostic disable-next-line
							return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
						end,
					},
				}

				-- INFO: Setting up the plugin itself
				require("mason").setup() -- Mason setup must run before csharp
				require("csharp").setup()
			end,
		},
	}
else
	return {}
end
