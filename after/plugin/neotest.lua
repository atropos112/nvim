-- For more info go to: https://github.com/nvim-neotest/neotest
require("neotest").setup({
  adapters = {
    require("neotest-python")({
		dap = {
			justMyCode = false
		},
    }),
	-- For all runners go to https://github.com/nvim-neotest/neotest#supported-runners
	--require("neotest-go"),
	require("nvim-ginkgo"),
	require("neotest-dotnet"),
  },
})
