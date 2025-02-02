---@type LazySpec[]
return {
	-- Section: Optimizes w,e and b motions by stop at the segments of a camelCase, SNAKE_CASE, or kebab-case variable and not just based on spaces/other separators themselves.
	{
		"chrisgrieser/nvim-spider",
		lazy = true,
		event = "VeryLazy",
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
