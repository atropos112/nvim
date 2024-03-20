return {
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local dappy = require("dap-python")
			dappy.setup("/turbo/jkiedrowski/pyenvs/nvim/bin/python")
			dappy.test_runner = "pytest"
		end,
	},
	{
		"roobert/f-string-toggle.nvim",
		ft = "python",
		opts = {
			key_binding = "<leader>f",
			key_binding_desc = "Toggle f-string",
		},
	},
}
