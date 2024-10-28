---@type LazySpec[]
return {
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		config = function()
			local custom_cfg = GCONF.mason_config or {}

			require("mason").setup(
				---@type MasonSettings
				{
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
					pip = {
						upgrade_pip = true,
						install_args = custom_cfg["pip_install_args"] or {},
					},
				}
			)
		end,
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
