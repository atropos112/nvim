if GCONF.languages["rust"] then
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "rust", -- filetype for which to run the autocmd
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			require("atro.lsp.utils").set_lsp_keymaps(bufnr)
		end,
	})
	return {
		{
			"mrcjkb/rustaceanvim",
			version = "^5",
			lazy = false,
			ft = { "rust" },
			config = function()
				require("atro.mason").ensure_installed("rust_analyzer")
				-- INFO: Do not need to call require("rustaceanvim") it does it itself (somehow)
			end,
		},
		{
			"saecki/crates.nvim",
			tag = "stable",
			event = "BufRead",
			ft = { "toml" },
			opts = {},
		},
	}
else
	return {}
end
