---@type LazyPlugin[]
return {
	-- Section: Plugin to create docstrings and annotations for functions, classes, etc.
	{
		"danymat/neogen",
		event = { "VeryLazy" }, -- For some reason, the plugin doesn't work without this event
		config = function()
			local neogen = require("neogen")
			local keymap = KEYMAPS.comments.generate_annotation

			neogen.setup({
				{
					snippet_engine = "luasnip",
					languages = {
						python = {
							template = {
								annotation_convention = "google_docstrings",
							},
						},
					},
				},
			})

			KEYMAPS:set(keymap, neogen.generate)
		end,
	},

	-- Section: Highlights comments when starting with correct keywards (like `TODO`, `FIXME`, etc.)
	{
		"folke/todo-comments.nvim",
		event = { "VeryLazy" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = " ", color = "info", alt = { "FIXME" } },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				SECTION = { icon = " ", alt = { "SEC", "Section" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		},
	},
	-- Section: Comment plugin, support for treesitter, dot-repeats, left-right-up-down motions and hooks.
	{
		"numToStr/Comment.nvim",
		event = { "VeryLazy" },
		config = function()
			local keys = KEYMAPS.comments

			require("Comment").setup(
				---@type CommentConfig
				{
					mappings = {
						-- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
						basic = true,

						-- Extra mapping; `gco`, `gcO`, `gcA`
						extra = true,
					},

					toggler = {
						line = keys.toggle_comment_line.key,
						block = keys.toggle_comment_block.key,
					},

					opleader = {
						line = KEYMAPS:key_without_leader(keys.operator_pending_line),
						block = KEYMAPS:key_without_leader(keys.operator_pending_block),
					},

					extra = {
						above = keys.comment_above.key,
						below = keys.comment_below.key,
						eol = keys.comment_end_of_line.key,
					},
				}
			)
		end,
	},
}
