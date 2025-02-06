if CONFIG.languages["yaml"] then
	return {
		{
			"towolf/vim-helm",
			ft = { "yaml" },
			lazy = true,
			event = { "VeryLazy" },
		},
	}
else
	return {}
end
