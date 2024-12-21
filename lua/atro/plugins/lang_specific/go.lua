if GCONF.languages["go"] then
	return {
		-- INFO: Can use fatih/vim-go or ray-x/go.nvim but they both seem unecessarily bloated
		-- This plugin has also (somehow) figured out how to run debug tests for ginkgo and go test
		-- With basically zero setup. And get to use my own LSP configs so renames etc work.
		{
			"olexsmir/gopher.nvim",
			ft = "go",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				"mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
			},
			config = function()
				require("atro.mason").ensure_installed({
					"gomodifytags",
					"gotests",
					"impl",
					"iferr",
					-- "dlv", -- INFO: as a dap package it already gets installed
				})

				-- TODO: Add bunch of keymaps for go-specific commands look at
				-- https://github.com/olexsmir/gopher.nvim to see what commands are available
				-- from the plugin itself.

				require("gopher").setup(
					---@type gopher.Config
					{}
				)
				require("gopher.dap").setup()
			end,
		},
	}
else
	return {}
end
