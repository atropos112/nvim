local key = require("atro.utils").keyset

---@type LazyPlugin[]
return {
	{
		"danymat/neogen",
		opts = true,
		keys = {
			{
				"<leader>a",
				function()
					require("neogen").generate()
				end,
				desc = "Add Docstring",
			},
		},
	},
	{
		"chrisgrieser/nvim-rulebook",
		keys = {
			{
				"<leader>Ri",
				function()
					require("rulebook").ignoreRule()
				end,
			},
			{
				"<leader>Rl",
				function()
					require("rulebook").lookupRule()
				end,
			},
			{
				"<leader>Ry",
				function()
					require("rulebook").yankDiagnosticCode()
				end,
			},
			{
				"<leader>sf",
				function()
					require("rulebook").suppressFormatter()
				end,
				mode = { "n", "x" },
			},
		},
		opts = {},
	},
	{
		"saecki/live-rename.nvim",
		event = "LspAttach",
		config = function()
			local live_rename = require("live-rename")

			live_rename.setup({})
			key("n", "gy", live_rename.map({ insert = true }), { desc = "LSP rename" })
		end,
	},
	{
		"chrisgrieser/nvim-puppeteer",
		event = "BufRead",
	},
	{
		-- TODO: Analyze all keys
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		event = "BufRead",
		opts = {
			mappings = {
				basic = true,
				extra = true,
			},
		},
	},
	-- {
	-- 	"smoka7/multicursors.nvim",
	-- 	event = "VeryLazy",
	-- 	dependencies = {
	-- 		"smoka7/hydra.nvim",
	-- 	},
	-- 	opts = {},
	-- 	cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
	-- 	keys = {
	-- 		{
	-- 			mode = { "v", "n" },
	-- 			"<Leader>n",
	-- 			"<cmd>MCstart<cr>",
	-- 			desc = "Create a selection for selected text or word under the cursor",
	-- 		},
	-- 	},
	-- },
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
		opts = {
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				SECTION = { icon = " ", alt = { "SEC", "Section" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		},
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
		opts = {
			post_close_hook = function()
				GOTO_PREVIEW_ALREADY_SHIFTED = false
			end,
			post_open_hook = function(_, win_id)
				if GOTO_PREVIEW_ALREADY_SHIFTED then
					return
				end

				-- Get the current window dimensions
				local width = vim.api.nvim_win_get_width(win_id)
				local height = vim.api.nvim_win_get_height(win_id)

				-- Get the dimensions of the Neovim editor
				local editor_width = vim.o.columns
				local editor_height = vim.o.lines

				-- Calculate the new position for the upper right corner
				local new_row = 0 -- Top of the screen
				local new_col = editor_width - width -- Right side of the screen

				-- -- Move the floating window
				-- vim.api.nvim_win_set_config(win_id, {
				-- 	relative = "editor",
				-- 	row = new_row,
				-- 	col = new_col,
				-- })
				-- Move the floating window
				GOTO_PREVIEW_ALREADY_SHIFTED = true

				vim.api.nvim_win_set_config(win_id, {
					relative = "editor",
					row = new_row,
					col = new_col,
					width = width, -- Maintain the current width
					height = height, -- Maintain the current height
				})
			end, -- A function taking two arguments, a buffer and a window to be ran as a hook.
		},
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
		lazy = true,
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
	-- Section: Plugin to show outline of the file in a window.
	-- Showing a side window (on the right) with functions, classes, variables etc.
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		config = function()
			local outline = require("outline")
			outline.setup({})
			KEYMAPS:set(KEYMAPS.other.show_file_outline, outline.toggle)
		end,
	},
	-- Section: Plugin to show number of references, implementations etc. on top of a class or function.
	{
		"VidocqH/lsp-lens.nvim",
		event = { "LspAttach" },
		opts = {
			include_declaration = false, -- Reference include declaration
			sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
				definition = true, -- Most of the time just prints "Definitions: 1" which is unecessary clutter.
				references = true,
				implements = true,
				git_authors = false, -- Unecessary clutter.
			},
		},
	},
	-- Section: Plugin to show window bar with current function, class, etc.
	-- The plugin is deprecated and I haven't found a replacement yet.
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		event = { "BufRead" },
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		-- No type available for the setup config (checked).
		opts = {
			-- INFO: Not attaching navic here as it would cause already attached errors when using multiple LSPs (see on_attach where it is attached with special logic)
			attach_navic = false,
			show_modified = true,
		},
	},
	-- Section: Plugin to highlight the line initiating yank, delete or replace operations
	-- For example first 'y' will highlight the line, while second 'y' will actually yank the line.
	-- The second 'y' yanking is normal behaviour but the highlighting is done by this plugin.
	-- Similar for 'dd' and 'R' operations.
	{
		"mvllow/modes.nvim",
		event = { "BufRead" },
		-- No type available for the setup config (checked).
		opts = {
			line_opacity = 0.30,
		},
	},
	-- Section: Plugin to persist clipboard history between sessions
	-- Shows the history in a telescope window when <CR> is pressed the selected
	-- item is stored into buffer ready to be pasted.
	-- Alternatively can press <c-p> to paste the selected item directly.
	{
		"AckslD/nvim-neoclip.lua",
		event = { "BufEnter" },
		dependencies = {
			"kkharji/sqlite.lua", -- Needs to persist paste history between sessions
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local keys = KEYMAPS.buffer

			-- No type available for the setup config (checked).
			require("neoclip").setup({
				enable_persistent_history = true,
				default_register = "+",
				db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3", -- Default, set for clarity
				keys = {
					telescope = {
						i = {
							select = keys.select_from_paste_history.key,
							paste = keys.insert_from_paste_history.key,
						},
						n = {
							select = keys.select_from_paste_history.key,
							paste = keys.insert_from_paste_history.key,
						},
					},
				},
			})

			KEYMAPS:set(keys.show_paste_history, "<cmd>Telescope neoclip<cr>")
		end,
	},
	-- Section: Plugin to jump around the file quicker.
	-- Improves t/T, f/F keys by highlighting the jump target.
	-- Also adds two more keys which highlight next jump places of occurence of char
	-- or treesitter focal points.
	{
		"folke/flash.nvim",
		event = { "VeryLazy" },
		config = function()
			local keys = KEYMAPS.position
			local flash = require("flash")

			flash.setup(
				---@type Flash.Config
				{}
			)

			KEYMAPS:set_many({
				{ keys.flash_jump, require("flash").jump },
				{ keys.flash_treesitter, require("flash").treesitter },
			})
		end,
	},
}
