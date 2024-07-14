return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				hover = {
					enabled = false, -- to allow better diagnostic virtual text
				},
				signature = {
					enabled = false,
				},
				progress = {
					enabled = false,
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {},
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({
				chunk = {
					style = "#00ffff",
					enable = true,
					delay = 0,
					duration = 50,
				},
			})
		end,
	},
}
