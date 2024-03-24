return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				direction = "float",
				border = "single",
				open_mapping = [[<c-\>]], -- without this closing is not easy.
			})
		end,
		cmd = {
			"ToggleTerm",
			"TermExec",
			"ToggleTermToggleAll",
			"ToggleTermSendCurrentLine",
			"ToggleTermSendVisualLines",
			"ToggleTermSendVisualSelection",
		},
		keys = {
			{ [[<c-\>]], "<cmd>lua require('toggleterm').toggle()<CR>", desc = "Toggle Terminal Window" },
		},
	},
}
