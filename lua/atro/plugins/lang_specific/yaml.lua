if CONFIG.languages["yaml"] then
	vim.filetype.add({
		-- extension = {},
		-- filename = {},
		pattern = {
			-- can be comma-separated for a list of paths
			[".*/%.github/dependabot.yml"] = "dependabot",
			[".*/%.github/dependabot.yaml"] = "dependabot",
			[".*/%.github/workflows[%w/]+.*%.yml"] = "gha",
			[".*/%.github/workflows/[%w/]+.*%.yaml"] = "gha",
		},
	})

	-- use the yaml parser for the custom filetypes
	vim.treesitter.language.register("yaml", "gha")
	vim.treesitter.language.register("yaml", "dependabot")

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
