local set = require("atro.utils.generic").keyset
return {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		lazy = true,
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			local telescope = require("telescope")
			---@diagnostic disable-next-line: no-unknown
			local builtin = require("telescope.builtin")
			telescope.setup({
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					smart_open = {
						match_algorithm = "fzf",
						show_scores = true,
					},
				},
			})

			telescope.load_extension("fzf")

			-- ZSA Moonlander specific
			set("n", "<A-f>", builtin.find_files, {})
			set("n", "<A-p>", builtin.live_grep, {})

			-- General
			set("n", ";g", builtin.live_grep, {})
			set("n", ";o", builtin.oldfiles, {})
			set("n", ";b", builtin.buffers, {})
			set("n", ";p", builtin.find_files, {})
		end,
	},

	-- Finds files not just inside the dir but outside and it uses fzf for it as well.
	{
		"danielfalk/smart-open.nvim",
		branch = "0.2.x",
		lazy = true,
		config = function()
			require("telescope").load_extension("smart_open")
		end,
		keys = {
			{ ";f", "<cmd>Telescope smart_open<CR>", desc = "Telescope file search" },
		},
		dependencies = {
			"kkharji/sqlite.lua",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
	},
}
