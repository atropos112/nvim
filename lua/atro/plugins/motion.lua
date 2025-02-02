---@type LazySpec[]
return {
	-- Section: Overloads tab to jump out of the brackets when inside of them so that { | } -> { } | or ( | ) -> ( ) |
	{
		"abecodes/tabout.nvim",
		lazy = true,
		event = { "InsertCharPre" }, -- Set the event to 'InsertCharPre' for better compatibility
		config = function()
			require("tabout").setup({
				tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
				backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
				act_as_tab = true, -- shift content if tab out is not possible
				act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
				default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
				default_shift_tab = "<C-d>", -- reverse shift default action,
				enable_backwards = true, -- well ...
				completion = false, -- if the tabkey is used in a completion pum
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = "`", close = "`" },
					{ open = "(", close = ")" },
					{ open = "[", close = "]" },
					{ open = "{", close = "}" },
				},
				ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
				exclude = {}, -- tabout will ignore these filetypes
			})
		end,
		dependencies = { -- These are optional
			"nvim-treesitter/nvim-treesitter",
			"L3MON4D3/LuaSnip",
		},
		opt = {},
	},
	-- Section: Optimizes w,e and b motions by stop at the segments of a camelCase, SNAKE_CASE, or kebab-case variable and not just based on spaces/other separators themselves.
	{
		"chrisgrieser/nvim-spider",
		lazy = true,
		event = { "VeryLazy", "InsertCharPre" },
		config = function()
			local keys = KEYMAPS.motion
			local spider = require("spider")

			spider.setup({
				{
					skipInsignificantPunctuation = true,
					consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
					subwordMovement = true,
					customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
				},
			})

			KEYMAPS:set_many({
				{
					keys.go_back_to_previous_word,
					function()
						spider.motion("b")
					end,
				},
				{
					keys.go_to_beginning_of_word,
					function()
						spider.motion("w")
					end,
				},
				{
					keys.go_to_end_of_word,
					function()
						spider.motion("e")
					end,
				},
			})
		end,
	},
}
