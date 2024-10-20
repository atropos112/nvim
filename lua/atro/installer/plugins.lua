local M = {}

M.installer_plugins = function()
	---@type LazySpec[]
	local plugins = {
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
				require("atro.installer.installer").ensure_user_requested_are_installed()
			end,
		},
	}

	return plugins
end

return M
