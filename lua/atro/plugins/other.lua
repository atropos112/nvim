return {
	-- API info of vim
	"folke/neodev.nvim",

	-- Tract time usage
	"wakatime/vim-wakatime",

	-- Downloads dependencies for LSP, formatter and debugger
	{
		"williamboman/mason.nvim",
		opts = {}
	},

	-- Tells you what keybindings are available
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	
	-- Nice loading graphics (on bottom right)
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		tag = "legacy",
		config = function()
			require("fidget").setup {}
		end,
	},

	-- Keep track of startup time
	{
		"dstein64/vim-startuptime",
		-- lazy-load on a command
		cmd = "StartupTime",
		-- init is called during startup. Configuration for vim plugins typically should be set in an init function
		init = function()
			vim.g.startuptime_tries = 10
		end,
	},

}
