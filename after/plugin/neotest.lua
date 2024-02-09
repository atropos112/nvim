-- For more info go to: https://github.com/nvim-neotest/neotest
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
		-- .NET
		require("neotest-dotnet"),
		-- Rust
		require("neotest-rust"),
	},
})
