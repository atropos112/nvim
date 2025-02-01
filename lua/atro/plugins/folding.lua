---@type LazyPlugin[]
return {
	-- Section: Plugin overloads h and l to fold/unfold if the cursor is at the start of the line, otherwise it moves the cursor
	-- as usual. Very natural, and small plugin.
	{
		"chrisgrieser/nvim-origami",
		event = { "VeryLazy" },
		opts = {}, -- needed even when using default config
	},
	-- Section: Adds some nicer folding capabilities, like folding based on treesitter or indent.
	-- Also offers fold all and unfold all commands.
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		event = { "LspAttach" },
		config = function()
			local ufo = require("ufo")
			local keys = KEYMAPS.fold

			ufo.setup({
				provider_selector = function(_, _, _)
					return { "treesitter", "indent" }
				end,
			})
			KEYMAPS:set_many({
				{ keys.open_fold, "zo" }, -- "zo" is default we are "mapping" to
				{ keys.close_fold, "zc" }, -- "zc" is default we are "mapping" to
				{ keys.open_all_folds, ufo.openAllFolds },
				{ keys.close_all_folds, ufo.closeAllFolds },
			})
		end,
	},
}
