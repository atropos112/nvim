local mason_install_root_dir = os.getenv("HOME") .. "/.local/share/nvim-mason"
---@type LazySpec[]
return {
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		config = function()
			---@type MasonConfig
			local custom_cfg = CONFIG.mason_config or {}

			require("mason").setup(
				---@type MasonSettings
				{
					install_root_dir = mason_install_root_dir,
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
						install_args = custom_cfg.pip_install_args or {},
					},
				}
			)
			require("atro.mason").ensure_packages_are_installed()
		end,
	},
}
