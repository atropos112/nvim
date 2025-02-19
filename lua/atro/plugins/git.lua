if require("atro.utils").is_git_dir() then
	return {
		{
			-- TODO: Make keymap to open this (require('gitgraph').draw({}, { all = true, max_count = 5000 }))
			-- TODO: Figure out how to conviniently close diffview after selecting (currently its via :tabc)
			"isakbm/gitgraph.nvim",
			event = "VeryLazy",
			dependencies = { "sindrets/diffview.nvim" },
			---@type I.GGConfig
			opts = {
				hooks = {
					-- Check diff of a commit
					on_select_commit = function(commit)
						vim.notify("DiffviewOpen " .. commit.hash .. "^!")
						vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
					end,
					-- Check diff from commit a -> commit b
					on_select_range_commit = function(from, to)
						vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
						vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
					end,
				},
			},
		},
		{
			"tpope/vim-fugitive",
			event = "VeryLazy",
		},
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
			event = { "VeryLazy" },
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
			event = { "VeryLazy" },
			config = function()
				---@type table<string, function>
				local callbacks = {
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
				}

				---@type table<string, function>
				local extra_callbacks = {}

				if CONFIG.extra_git_linker_callbacks and type(CONFIG.extra_git_linker_callbacks) == "function" then
					extra_callbacks = CONFIG.extra_git_linker_callbacks()
				elseif CONFIG.extra_git_linker_callbacks then
					-- INFO: Its either a function or a table
					---@diagnostic disable-next-line: cast-local-type
					extra_callbacks = CONFIG.extra_git_linker_callbacks
				end

				if #extra_callbacks > 0 then
					LOGGER:debug("Extra callbacks for GitLinker found, extending the default callbacks list.")
				end

				---@diagnostic disable-next-line: param-type-mismatch
				callbacks = vim.tbl_extend("force", callbacks, extra_callbacks)

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
					callbacks = callbacks,
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
				"nvim-telescope/telescope.nvim", -- optional
				"lewis6991/gitsigns.nvim",
			},
			config = true,
			keys = {
				{
					"<leader>gg",
					function()
						local Hydra = require("hydra")
						local gitsigns = require("gitsigns")

						local hint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _<Enter>_: Neogit              _q_: exit
]]
						Hydra({
							name = "Git",
							hint = hint,
							config = {
								buffer = true,
								color = "pink",
								invoke_on_body = true,
								hint = {
									border = "rounded",
								},
								on_enter = function()
									vim.cmd("mkview")
									vim.cmd("silent! %foldopen!")
									vim.bo.modifiable = false
									gitsigns.toggle_signs(true)
									gitsigns.toggle_linehl(true)
								end,
								on_exit = function()
									local cursor_pos = vim.api.nvim_win_get_cursor(0)
									vim.cmd("loadview")
									vim.api.nvim_win_set_cursor(0, cursor_pos)
									vim.cmd("normal zv")
									gitsigns.toggle_signs(false)
									gitsigns.toggle_linehl(false)
									gitsigns.toggle_deleted(false)
								end,
							},
							mode = { "n", "x" },
							body = "<leader>gg",
							heads = {
								{
									"J",
									function()
										if vim.wo.diff then
											return "]c"
										end
										vim.schedule(function()
											gitsigns.next_hunk()
										end)
										return "<Ignore>"
									end,
									{ expr = true, desc = "next hunk" },
								},
								{
									"K",
									function()
										if vim.wo.diff then
											return "[c"
										end
										vim.schedule(function()
											gitsigns.prev_hunk()
										end)
										return "<Ignore>"
									end,
									{ expr = true, desc = "prev hunk" },
								},
								{ "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "stage hunk" } },
								{ "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
								{ "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
								{ "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
								{ "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
								{ "b", gitsigns.blame_line, { desc = "blame" } },
								{
									"B",
									function()
										gitsigns.blame_line({ full = true })
									end,
									{ desc = "blame show full" },
								},
								{ "/", gitsigns.show, { exit = true, desc = "show base file" } }, -- show the base of the file
								{ "<Enter>", "<Cmd>Neogit<CR>", { exit = true, desc = "Neogit" } },
								{ "q", nil, { exit = true, nowait = true, desc = "exit" } },
							},
						})
					end,
					desc = "Neogit",
				},
			},
		},
	}
else
	return {}
end
