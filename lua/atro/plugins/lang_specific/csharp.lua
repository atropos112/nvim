return {
	{
		"iabdelkareem/csharp.nvim",
		ft = "cs",
		dependencies = {
			"williamboman/mason.nvim", -- Required, automatically installs omnisharp
			"Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
		},
		config = function()

            require("atro.utils.mason").install({
                -- lsp
                "omnisharp",

                -- debugger
                "netcoredbg",
            })

			local csharp = require("csharp")
			local dap = require('dap')


			csharp.setup({
				lsp = {
					analyze_open_documents_only = true,
					enable_editor_config_support = true,
				}
			})

            -- Debugger 
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

            -- Keymaps (note we don't have default keymaps for LSP here)
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
