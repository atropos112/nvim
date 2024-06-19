return {
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-extensions/nvim-ginkgo",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-python",
			"rouge8/neotest-rust",
			"Issafalcon/neotest-dotnet",
		},
		keys = {
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run tests",
			},
			{
				"<leader>td",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Run tests with DAP",
			},
			{
				"<leader>ts",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop tests",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle watch",
			},
			{
				"<leader>tt",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle output panel",
			},
		},
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			-- INFO: This can't be set in opts because the dependencies are not loaded yet at that time.
			require("neotest").setup({

				adapters = {
					-- For all runners go to https://github.com/nvim-neotest/neotest#supported-runners
					-- Python
					require("neotest-python")({
						dap = {
							justMyCode = false,
						},
					}),
					-- Go
					require("neotest-go"),
					--require("nvim-ginkgo"),
					-- .NET
					require("neotest-dotnet"),
					-- Rust
					require("neotest-rust"),
				},
			})
		end,
	},
}
