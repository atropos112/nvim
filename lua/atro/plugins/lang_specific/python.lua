if require("atro.utils.config").IsLangSupported("python") then
	return {
		{
			"mfussenegger/nvim-dap-python",
			ft = "python",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
			config = function()
				require("atro.utils.load").install("debugpy")
				local dappy = require("dap-python")
				local dap_path = _G.user_conf.SupportedLanguages.python.DAP.path
				if dap_path then
					dappy.setup(dap_path)
				else
					dappy.setup()
				end
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
else
	return {}
end
