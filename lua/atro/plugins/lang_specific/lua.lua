if require("atro.utils.config").IsLangSupported("lua") then
	return {
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			dependencies = {
				"Bilal2453/luvit-meta",
			},
			opts = {
				library = {
					"luvit-meta/library",
					"lazy.nvim",
				},
				-- always enable unless `vim.g.lazydev_enabled = false`
				-- This is the default
				enabled = function(_)
					return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
				end,
			},
		},
	}
else
	return {}
end
