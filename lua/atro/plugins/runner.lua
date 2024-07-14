return {
	{
		"Zeioth/compiler.nvim",
		cmd = {
			"CompilerOpen",
			"CompilerToggleResults",
			"CompilerRedo",
		},
		dependencies = { "stevearc/overseer.nvim" },
		opts = {},
	},
	{
		"stevearc/overseer.nvim",
		event = "VeryLazy",
		opts = {
			task_list = {
				direction = "bottom",
				min_height = 25,
				max_height = 25,
				default_detail = 1,
			},
		},
	},

	{
		"michaelb/sniprun",
		branch = "master",

		build = "sh install.sh",
		-- do 'sh install.sh 1' if you want to force compile locally
		-- (instead of fetching a binary from the github release). Requires Rust >= 1.65

		config = function()
			require("sniprun").setup({
				-- your options
				--
				selected_interpreters = { "Python3_fifo" },
				repl_enable = { "Python3_fifo" },
			})
		end,
	},
}
