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
	{
		"saecki/live-rename.nvim",
		event = { "LspAttach" },
		config = function()
			local live_rename = require("live-rename")

			live_rename.setup({})
			key("n", "gy", live_rename.map({ insert = true }), { desc = "LSP rename" })
		end,
	},
	{
		"chrisgrieser/nvim-puppeteer",
		event = { "BufRead" },
	},
	-- Section: Plugin to pop-up a window with the definition of a function or variable.
	-- The below implementation has window size set to 30% of the editor size and appaers in top right corner.
	-- Every next window will be 15px below the previous one (size of the window is 15px, so no overlap).
	{
		"rmagatti/goto-preview",
		event = { "BufRead" },
		config = function()
			local gtp = require("goto-preview")
			local keys = KEYMAPS.position

			gtp.setup({
				width = 120,
				height = 15,
				post_close_hook = function(_, _)
					-- It will be called many times over (I've seen -6 without this check...)
					if GOTO_PREVIEW_WIN_COUNT == 0 then
						return
					end

					GOTO_PREVIEW_WIN_COUNT = GOTO_PREVIEW_WIN_COUNT - 1
				end,
				post_open_hook = function(_, win_id)
					if GOTO_PREVIEW_WIN_COUNT == nil then
						-- Initialize the count
						GOTO_PREVIEW_WIN_COUNT = 0
					end
					-- Get the dimensions of the Neovim editor
					local editor_width = vim.o.columns
					local editor_height = vim.o.lines

					-- 30% of the editor size in both dimensions
					local new_height = math.floor(editor_height * 0.3)
					local new_width = math.floor(editor_width * 0.3)

					-- Position the window in the top right corner and 15px below the previous window (via counter)
					local new_col = editor_width - new_width
					local new_row = GOTO_PREVIEW_WIN_COUNT * 15

					vim.api.nvim_win_set_config(win_id, {
						relative = "editor",
						row = new_row,
						col = new_col,
						width = new_width,
						height = new_height,
					})

					GOTO_PREVIEW_WIN_COUNT = GOTO_PREVIEW_WIN_COUNT + 1
				end,
			})

			KEYMAPS:set_many({
				{ keys.open_goto_preview, gtp.goto_preview_definition },
				{ keys.close_all_goto_previews, gtp.close_all_win },
			})
		end,
	},
	-- Section: Plugin to peek at the line number we are jumping to when using :<n> inside of a file.
	{
		"nacro90/numb.nvim",
		event = { "BufRead" },
		opts = {},
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
