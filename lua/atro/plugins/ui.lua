return {
	{
		"RRethy/vim-illuminate",
		event = "LspAttach",
		opt = {},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					show_source = true,
					multilines = true,
					throttle = 0,
				},
			})
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
	{
		"folke/noice.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			-- Don't want written messages to be shown
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
			lsp = {
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

			-- INFO: This plugin is nice but not really necessary on its own
			-- However noice.nvim has dap selection broken and this plugin "plugs in" a version
			-- that works (over-writting the buggy behaviour)
			"stevearc/dressing.nvim",
		},
	},
	{
		"rcarriga/nvim-notify",
		version = "*",
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
