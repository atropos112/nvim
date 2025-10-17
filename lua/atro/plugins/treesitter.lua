return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		dependencies = {
			{ "LiadOz/nvim-dap-repl-highlights", opts = {} }, -- Has to be before ensure_installed is called
		},
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({
				-- WARN: You really do need the parser_install_dir in nixos setups.
				-- In non-nixos setups it's not necessary but won't hurt either.
				-- See https://unix.stackexchange.com/questions/735196/treesitter-neovim-plugin-not-working-on-nixos for details.
				parser_install_dir = vim.fn.stdpath("data") .. "/treesitter",
				auto_install = true,
				ignore_install = {},
				modules = {},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})

			local currently_installed = require("nvim-treesitter.config").get_installed()
			local ensure_installed = { "dap_repl", "regex" }

			for lang, lang_cfg in pairs(CONFIG.languages) do
				ensure_installed = vim.list_extend(ensure_installed, lang_cfg.treesitters or { lang })
			end

			for _, lang in ipairs(ensure_installed) do
				if not vim.tbl_contains(currently_installed, lang) then
					ts.install(lang)
				end
			end
		end,
	},
}
