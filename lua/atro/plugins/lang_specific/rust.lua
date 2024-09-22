if require("atro.utils.config").IsLangSupported("rust") then
	return {
		{
			"mrcjkb/rustaceanvim",
			version = "^5",
			lazy = false,
			ft = { "rust" },
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
