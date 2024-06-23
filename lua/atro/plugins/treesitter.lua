return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				ignore_install = {},
				modules = {},
				ensure_installed = require("atro.utils.config").SupportedLanguages(),
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
