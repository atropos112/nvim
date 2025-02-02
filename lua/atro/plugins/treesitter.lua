return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-dap-repl-highlights", opts = {} }, -- Has to be before ensure_installed is called
		},
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local ensure_installed = { "dap_repl" }

			for lang, lang_cfg in pairs(CONFIG.languages) do
				ensure_installed = vim.list_extend(ensure_installed, lang_cfg.treesitters or { lang })
			end

			require("nvim-treesitter.configs").setup({
				auto_install = true,
				ignore_install = {},
				modules = {},
				ensure_installed = ensure_installed,
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
