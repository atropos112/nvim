if require("atro.utils.config").IsLangSupported("markdown") then
	return {
		{
			-- INFO: Markdown preview functionality
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
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
			event = "BufEnter",
			opts = {},
			keys = {
				{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
			},
		},
		{
			"OXY2DEV/markview.nvim",
			ft = { "markdown" },
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
		},
	}
else
	return {}
end
