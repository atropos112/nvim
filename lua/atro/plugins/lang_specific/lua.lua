if CONFIG.languages["lua"] then
	return {
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			dependencies = {
				"Bilal2453/luvit-meta",
			},
			---@type lazydev.Config
			opts = {
				library = {
					"luvit-meta/library",
					"lazy.nvim",
					"LazyVim",
					"atro.types",
					"lazydev.nvim",
					"rabbit.nvim",
					"which-key.nvim",
					"dap",
					"gopher.nvim",
					"overseer.nvim",
					"dap",
					"conform.nvim",
					"nvim-dap",
					"Comment.nvim",
				},
				enabled = function()
					return true
				end,

				integrations = {
					cmp = true,
					lspconfig = true,
				},
			},
		},
	}
else
	return {}
end
