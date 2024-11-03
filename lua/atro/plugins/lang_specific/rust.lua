if GCONF.languages["rust"] then
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
