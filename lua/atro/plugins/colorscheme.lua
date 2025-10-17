return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- load before other plugins to keep theme consistent
		-- Loads by default
		init = function()
			vim.cmd.colorscheme("catppuccin")
		end,
		config = function()
			local is_git_dir = require("atro.utils").is_git_dir()
			local opts = {
				flavour = "macchiato", -- latte, frappe, macchiato, mocha
				integrations = {
					mason = true,
					blink_cmp = true,
					gitsigns = is_git_dir,
					nvimtree = true,
					treesitter = true,
					treesitter_context = true,
					ufo = true,
					overseer = true,
					dadbod_ui = true,
					which_key = true,
					notify = true,
					neotest = true,
					neogit = is_git_dir,
					diffview = true,
					dap_ui = true,
					dap = true,
					noice = true,
					flash = true,
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			}

			require("catppuccin").setup(opts)
		end,
	},
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {},
	-- 	-- Loads by default
	-- 	init = function()
	-- 		vim.cmd.colorscheme("tokyonight-storm")
	-- 	end,
	-- },
}
