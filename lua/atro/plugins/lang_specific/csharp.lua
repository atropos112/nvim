if require("atro.utils.config").IsLangSupported("c_sharp") then
	return {
		{
			"iabdelkareem/csharp.nvim",
			dependencies = {
				"williamboman/mason.nvim", -- Required, automatically installs omnisharp
				"mfussenegger/nvim-dap",
				"Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
			},
			ft = "cs",
			config = function()
				-- INFO: Setting up the plugin itself
				require("mason").setup() -- Mason setup must run before csharp
				require("csharp").setup()
			end,
		},
	}
else
	return {}
end
