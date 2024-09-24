return {
	{
		"f-person/git-blame.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
	},
	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				-- Open blame window
				blame = "<Leader>gb",
				-- Open file/folder in git repository
				browse = "<Leader>go",
			},
		},
	},
	{
		"ruifm/gitlinker.nvim",
		event = "BufRead",
		config = function()
			require("gitlinker").setup({
				opts = {
					-- remote = 'github', -- force the use of a specific remote
					-- adds current line to the url
					add_current_line = true,
					-- callback for what to do with the url
					action_callback = require("gitlinker.actions").copy_to_clipboard,
					-- print the url after performing the action
					print_url = true,
				},
				-- mappings to call url generation
				mappings = "<leader>gy",
				callbacks = {
					["github.com"] = require("gitlinker.hosts").get_github_type_url,
					["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
					["try.gitea.io"] = require("gitlinker.hosts").get_gitea_type_url,
					["codeberg.org"] = require("gitlinker.hosts").get_gitea_type_url,
					["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
					["try.gogs.io"] = require("gitlinker.hosts").get_gogs_type_url,
					["git.sr.ht"] = require("gitlinker.hosts").get_srht_type_url,
					["git.launchpad.net"] = require("gitlinker.hosts").get_launchpad_type_url,
					["repo.or.cz"] = require("gitlinker.hosts").get_repoorcz_type_url,
					["git.kernel.org"] = require("gitlinker.hosts").get_cgit_type_url,
					["git.savannah.gnu.org"] = require("gitlinker.hosts").get_cgit_type_url,
				},
			})
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		event = "VeryLazy",
		version = "*",
		config = true,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			"echasnovski/mini.pick", -- optional
		},
		config = true,
	},
}
