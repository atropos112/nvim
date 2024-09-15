return {
	{
		"Zeioth/compiler.nvim",
		cmd = {
			"CompilerOpen",
			"CompilerToggleResults",
			"CompilerRedo",
		},
		dependencies = { "stevearc/overseer.nvim" },
		keys = {
			{
				mode = { "n" },
				"<Leader>cc",
				"<cmd>CompilerOpen<cr>",
				desc = "Open the compiler window",
			},
			{
				mode = { "n" },
				"<Leader>cs",
				"<cmd>CompilerStop<cr>",
				desc = "Toggle the compiler results",
			},
			{
				mode = { "n" },
				"<Leader>ct",
				"<cmd>CompilerToggleResults<cr>",
				desc = "Toggle the compiler results",
			},
			{
				mode = { "n" },
				"<Leader>cr",
				"<cmd>CompilerStop<cr> <cmd>CompilerRedo<cr>",
				desc = "Recompile the current file",
			},
		},
		config = function()
			require("compiler").setup({})
		end,
		-- opts = {},
	},

	-- INFO: Can make custom tasks with https://github.com/stevearc/overseer.nvim/blob/master/doc/guides.md#custom-tasks
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
