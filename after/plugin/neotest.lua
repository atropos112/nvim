require("neotest").setup({
  adapters = {
    require("neotest-python")({
		dap = {
			justMyCode = false
		},
    }),
	--require("neotest-go"),
	require("nvim-ginkgo")
  },
})
