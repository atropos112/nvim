---@type LazyPlugin[]
return {
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
					return { "treesitter", "lsp" }
				end,
				close_fold_kinds_for_ft = {
					default = { "imports" },
				},
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
