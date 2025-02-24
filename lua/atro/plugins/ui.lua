return {
	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = {
			autocmd = { enabled = true },
		},
	},
	{
		"RRethy/vim-illuminate",
		event = "LspAttach",
		config = function()
			require("illuminate").configure({
				providers = {
					"lsp",
				},
			})
		end,
	},
	{
		"hiphish/rainbow-delimiters.nvim",
		event = "VeryLazy",
		lazy = true,
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")
			require("rainbow-delimiters.setup").setup(

				---@type rainbow_delimiters.config
				{

					strategy = {
						[""] = rainbow_delimiters.strategy["global"],
						vim = rainbow_delimiters.strategy["local"],
					},
					query = {
						[""] = "rainbow-delimiters",
						lua = "rainbow-blocks",
					},
					priority = {
						[""] = 110,
						lua = 210,
					},
					highlight = {
						"RainbowDelimiterYellow",
						"RainbowDelimiterBlue",
						"RainbowDelimiterOrange",
						"RainbowDelimiterGreen",
						"RainbowDelimiterViolet",
						"RainbowDelimiterCyan",
						"RainbowDelimiterRed",
					},
				}
			)
		end,
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
		branch = "main",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",

			-- INFO: This plugin is nice but not really necessary on its own
			-- However noice.nvim has dap selection broken and this plugin "plugs in" a version
			-- that works (over-writting the buggy behaviour)
			-- "stevearc/dressing.nvim",
		},

		-- event = "VeryLazy",
		opts = {
			popupmenu = {
				enabled = true,
			},
			-- Don't want written messages to be shown
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						any = {
							{ find = "Agent service not initialized" }, -- Copilot complains.
							{ find = "written" },
						},
					},
					opts = { skip = true },
				},
				{
					view = "notify",
					filter = {
						event = "msg_showmode",
						find = "recording",
					},
				},
			},
			presets = {
				lsp_doc_border = true,
			},
			lsp = {
				signature = {
					enabled = true,
				},
				progress = {
					enabled = true,
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
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
		event = { "VeryLazy" },
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
	{
		"sphamba/smear-cursor.nvim",
		event = "VeryLazy",
		opts = {},
	},
}
