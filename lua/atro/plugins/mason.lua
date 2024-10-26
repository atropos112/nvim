---@type LazySpec[]
return {
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"zapling/mason-lock.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-lock").setup({
				lockfile_path = os.getenv("HOME") .. "/.config/nvim/mason-lock.json",
			})
			require("atro.mason").ensure_packages_are_installed()
		end,
	},
}
