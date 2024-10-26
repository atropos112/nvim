if GCONF.languages["python"] then
	return {
		{
			"roobert/f-string-toggle.nvim",
			ft = "python",
			opts = {
				key_binding = "<leader>f",
				key_binding_desc = "Toggle f-string",
			},
		},
		{
			"mfussenegger/nvim-dap-python",
			ft = "python",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
			config = function()
				local dappy = require("dap-python")
				local dap_path = GCONF.languages["python"].other.debugpy_python_path

				if dap_path then
					dappy.setup(dap_path)
				else
					-- Trying to use the "python" we have in the path might not work if no debugpy there
					dappy.setup("python")
				end

				dappy.test_runner = "pytest"
			end,
		},
	}
else
	return {}
end
