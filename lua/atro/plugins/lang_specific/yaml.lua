if CONFIG.languages["rust"] then
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
