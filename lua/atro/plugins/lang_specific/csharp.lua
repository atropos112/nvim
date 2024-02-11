return {
	{
		"iabdelkareem/csharp.nvim",
		ft = "cs",
		dependencies = {
			"williamboman/mason.nvim", -- Required, automatically installs omnisharp
			"Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
		},
		config = function()
			local csharp = require("csharp")
			local dap = require('dap')

			csharp.setup({
				lsp = {
					analyze_open_documents_only = true,
					enable_editor_config_support = true,
				}
			})
			dap.adapters.netcoredbg = {
				type = 'executable',
				command = 'netcoredbg',
				args = { '--interpreter=vscode' }
			}

			dap.configurations.cs = {
				{
					type = "netcoredbg",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
					end,
				},

			}
			vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '', {
				noremap = true,
				silent = true,
				callback = function()
					csharp.go_to_definition()
				end
			})
		end
	}
}
