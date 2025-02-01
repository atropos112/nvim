return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- load before other plugins to keep theme consistent
		-- Loads by default
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end,
		opts = {
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			integrations = {
				mason = true,
				blink_cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				treesitter_context = true,
				ufo = true,
				overseer = true,
				dadbod_ui = true,
				which_key = true,
				notify = true,
				neotest = true,
				neogit = true,
				diffview = true,
				dap_ui = true,
				dap = true,
				noice = true,
				flash = true,
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		},
	},
}
