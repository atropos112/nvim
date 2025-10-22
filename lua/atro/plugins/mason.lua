---@type LazySpec[]
return {
	{
		"mason-org/mason.nvim",
		event = "VeryLazy",
		config = function()
			require("mason").setup(
				---@type MasonSettings
				{
					install_root_dir = os.getenv("HOME") .. "/.local/share/nvim-mason",
					max_concurrent_installers = 20,
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
					pip = {
						upgrade_pip = true,
						install_args = CONFIG.mason_config.pip_install_args or {},
					},
				}
			)
			require("atro.mason").ensure_packages_are_installed()
		end,
	},
}
