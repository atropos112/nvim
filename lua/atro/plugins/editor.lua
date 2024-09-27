return {
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
	{
		"smoka7/multicursors.nvim",
		event = "VeryLazy",
		dependencies = {
			"smoka7/hydra.nvim",
		},
		opts = {},
		cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
		keys = {
			{
				mode = { "v", "n" },
				"<Leader>n",
				"<cmd>MCstart<cr>",
				desc = "Create a selection for selected text or word under the cursor",
			},
		},
	},
	-- Adds matching pairs of brackets, quotes, etc.
	{
		-- INFO: Autopairs plugin, adds matching pairs of brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		-- INFO: Commenting plugin, allows commenting out lines and blocks of code
		"folke/todo-comments.nvim",
		event = "BufRead",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "LspAttach",
		-- INFO: zc folds, zo unfolds, below are extras
		keys = {
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				{ desc = "Open all folds" },
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				{ desc = "Close all folds" },
			},
		},
		opts = {
			provider_selector = function(_, _, _)
				return { "treesitter", "indent" }
			end,
		},
	},
	{
		"rmagatti/goto-preview",
		event = "BufRead",
		keys = {
			{
				"gp",
				function()
					require("goto-preview").goto_preview_definition()
				end,
				desc = "Goto Preview",
			},
			{
				"gP",
				function()
					require("goto-preview").close_all_win()
				end,
				desc = "Close all previews",
			},
		},
		opts = {},
	},
	{
		-- INFO: with :<n> you can peek at n-th line
		"nacro90/numb.nvim",
		event = "BufRead",
		opts = {},
	},
	{
		"danymat/neogen",
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Neogen Comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		-- lazy = true,
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					swap = {
						enable = true,
						swap_next = {
							["sp"] = "@parameter.inner", -- swap parameters/argument with next
							["sr"] = "@property.outer", -- swap object property with next
							["sf"] = "@function.outer", -- swap function with next
						},
						swap_previous = {
							["sP"] = "@parameter.inner", -- swap parameters/argument with prev
							["sR"] = "@property.outer", -- swap object property with prev
							["sF"] = "@function.outer", -- swap function with previous
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = { query = "@call.outer", desc = "Next function call start" },
							["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
							["]c"] = { query = "@class.outer", desc = "Next class start" },
							["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
							["]l"] = { query = "@loop.outer", desc = "Next loop start" },

							-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
							-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
							["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
						},
						goto_next_end = {
							["]F"] = { query = "@call.outer", desc = "Next function call end" },
							["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
							["]C"] = { query = "@class.outer", desc = "Next class end" },
							["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
							["]L"] = { query = "@loop.outer", desc = "Next loop end" },
						},
						goto_previous_start = {
							["[f"] = { query = "@call.outer", desc = "Prev function call start" },
							["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
							["[c"] = { query = "@class.outer", desc = "Prev class start" },
							["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
							["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
						},
						goto_previous_end = {
							["[F"] = { query = "@call.outer", desc = "Prev function call end" },
							["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
							["[C"] = { query = "@class.outer", desc = "Prev class end" },
							["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
							["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
						},
					},
				},
			})
		end,
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {
			-- Your setup opts here
		},
	},
	{
		"VidocqH/lsp-lens.nvim",
		event = "LspAttach",
		opts = {
			include_declaration = false, -- Reference include declaration
			sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
				definition = false,
				references = true,
				implements = true,
				git_authors = false,
			},
		},
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		event = "BufRead",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			attach_navic = false,
		},
	},
	{
		"aznhe21/actions-preview.nvim",
		event = "LspAttach",
		config = function()
			vim.keymap.set({ "v", "n" }, "ga", require("actions-preview").code_actions)
		end,
	},
	{
		"0xAdk/full_visual_line.nvim",
		keys = "V",
		opts = {},
	},
	{
		"mvllow/modes.nvim",
		event = "BufRead",
		opts = {
			line_opacity = 0.30,
		},
	},
	{
		"AckslD/nvim-neoclip.lua",
		-- lazy = true,
		event = "BufEnter",
		dependencies = {
			"kkharji/sqlite.lua",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{
				"<leader>pp",
				"<cmd>Telescope neoclip<cr>",
				desc = "Open neoclip",
			},
		},
		opts = {
			enable_persistent_history = true,
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
		},
	},
}
