return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-extensions/nvim-ginkgo",
			--"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-python",
			"rouge8/neotest-rust",
			"Issafalcon/neotest-dotnet",
		},
		event = "VeryLazy",
		config = function()
			local neotest = require("neotest")

			neotest.setup({
				adapters = {
					-- For all runners go to https://github.com/nvim-neotest/neotest#supported-runners
					-- Python
					require("neotest-python")({
						dap = {
							justMyCode = false,
						},
					}),
					-- Go
					--require("neotest-go"),
					require("nvim-ginkgo"),
					-- .NET
					require("neotest-dotnet"),
					-- Rust
					require("neotest-rust"),
				},
			})


			vim.keymap.set('n', '<leader>tr', function() neotest.run.run() end)
			vim.keymap.set('n', '<leader>td', function() neotest.run.run({strategy = "dap"}) end)
			vim.keymap.set('n', '<leader>ts', function() neotest.run.stop() end)
			vim.keymap.set('n', '<leader>tw', function() neotest.watch.toggle(vim.fn.expand("%")) end)
			vim.keymap.set('n', '<leader>tt', function() neotest.summary.toggle() end)
			vim.keymap.set('n', '<leader>to', function() neotest.output_panel.toggle() end)

			vim.keymap.set('n', '<leader>of', function() vim.diagnostic.open_float() end)
		end,
	},
}
