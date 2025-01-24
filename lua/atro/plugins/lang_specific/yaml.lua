if CONFIG.languages["yaml"] then
	return {
		{
			"towolf/vim-helm",
			ft = { "yaml" },
			lazy = true,
		},
	}
else
	return {}
end
