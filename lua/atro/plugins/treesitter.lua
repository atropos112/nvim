return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false, -- Don't lazy load
		branch = "main",
		dependencies = {
			{ "LiadOz/nvim-dap-repl-highlights", opts = {} }, -- Has to be before ensure_installed is called
		},
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({
				-- WARN: You really do need the parser_install_dir in nixos setups.
				-- In non-nixos setups it's not necessary but won't hurt either.
				-- See https://unix.stackexchange.com/questions/735196/treesitter-neovim-plugin-not-working-on-nixos for details.
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			local currently_installed = require("nvim-treesitter.config").get_installed()
			local ensure_installed = { "dap_repl", "regex" }
			local to_install = {}

			for lang, lang_cfg in pairs(CONFIG.languages) do
				ensure_installed = vim.list_extend(ensure_installed, lang_cfg.treesitters or { lang })
			end

			for _, lang in ipairs(ensure_installed) do
				if not vim.tbl_contains(currently_installed, lang) then
					table.insert(to_install, lang)
				end
			end

			if #to_install > 0 then
				ts.install(to_install):wait(300000) -- wait max. 5 minutes
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = ensure_installed,
				callback = function()
					vim.treesitter.start() -- Highlighting on etc.
				end,
			})
		end,
	},
}
