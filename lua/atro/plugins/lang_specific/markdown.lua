if CONFIG.languages["markdown"] then
	---@type LazyPlugin[]
	return {
		{
			"HakonHarnes/img-clip.nvim",
			event = { "VeryLazy" },
			opts = {},
			keys = {
				{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
			},
		},
		{
			-- INFO: Markdown preview functionality
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			lazy = true,
			build = "cd app && yarn install",
			init = function()
				vim.g.mkdp_filetypes = { "markdown" }
			end,
			-- WARN: Do not put opts, it will break the plugin
			ft = { "markdown" },
		},
		{
			-- INFO: Allows pasting images into markdown files
			"HakonHarnes/img-clip.nvim",
			ft = { "markdown" },
			event = { "VeryLazy" },
			opts = {},
			keys = {
				{ "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
			},
		},
		{
			"OXY2DEV/markview.nvim",
			ft = { "markdown" },
			event = { "VeryLazy" },
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("markview").setup({
					preview = {
						modes = { "n", "no", "c" },
						hybrid_modes = { "n" },
						callbacks = {
							on_enable = function(_, win)
								vim.wo[win].conceallevel = 2
								vim.wo[win].concealcursor = "c"
							end,
						},
					},
				})
			end,
		},
		{
			"OXY2DEV/helpview.nvim",
			lazy = true,
			ft = { "help" },
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
		},
	}
else
	return {}
end
