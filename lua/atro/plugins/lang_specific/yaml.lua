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
			[".*/templates/.*%.yaml"] = "helm",
			[".*/templates/.*%.yml"] = "helm",
		},
	})

	-- use the yaml parser for the custom filetypes
	vim.treesitter.language.register("yaml", "gha")
	vim.treesitter.language.register("yaml", "dependabot")
	vim.treesitter.language.register("yaml", "helm")
end

return {}
