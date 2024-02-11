return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- load before other plugins to keep theme consistent
		-- Loads by default
		init = function()
			vim.cmd.colorscheme "catppuccin"
		end,
		opts = {
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			integrations = {
				mason = true,
				cmp = true,
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		}
	}
}
