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
					-- To include all by putting this path: 
				    -- '~/.local/share/nvim/lazy/',
					-- But that would be slow af.
					-- These have to be the names of the folders inside the lazy directory
					"luvit-meta/library",
					"lazy.nvim",
					"LazyVim",
					"lazydev.nvim",
					"rabbit.nvim",
					"which-key.nvim",
					"overseer.nvim",
					"conform.nvim",
					"nvim-dap",
					"Comment.nvim",
					"dropbar.nvim",
					"rainbow-delimiters.nvim",
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
