return {
	-- Undo tree i.e. a fancy "go back"  history
	{
		"mbbill/undotree",
		event = "VeryLazy",
		config = function()
			vim.g.undotree_WindowLayout = 2
			vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
		end,
	},
}
