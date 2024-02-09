return {
	-- Allows to comment line(s) with language understanding (different languages comment out differently)
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- Theme (OneDark)
	{
		"navarasu/onedark.nvim",
		priority = 1000,
		config = function()
			require("onedark").load()
		end,
	},

	--- Autocomplete
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-nvim-lsp",
		},
	},

	-- Bottom line (with basic info)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				icons_enabled = true,
				theme = "onedark",
			})
		end,
	},

	-- SYntax highlighting for programming languages
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	-- Browsing and fuzzy finding files and dirs
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},

	-- Simplifies getting LSP servers
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",

	-- Quickstart configs for LSPs
	"neovim/nvim-lspconfig",

	-- Full signature help, docs and completion for the nvim lua API's.
	"folke/neodev.nvim",

	-- Golang plugin (all the lagnuage niceties in one plugin)
	"fatih/vim-go",

	-- Debugging functionality
	"mfussenegger/nvim-dap",
	"rcarriga/nvim-dap-ui",

	-- Debugging functionality for go
	"leoluz/nvim-dap-go",

	-- Testing framework
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-python",
			"rouge8/neotest-rust",
			"Issafalcon/neotest-dotnet",
		},
	},

	-- Terminal support
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
			})
		end,
	},

	-- Github Copilot
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = "<C-CR>",
					},
				},
			})
		end,
	},

	-- Undo tree i.e. a fancy "go back"  history
	{
		"mbbill/undotree",
		config = function()
			vim.g.undotree_WindowLayout = 2
			vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
		end,
	},

	-- File switcher
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	-- Rust support
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
	},

	-- Formatting (on save and more)
	{
		"sbdchd/neoformat",
	},

	-- Adds matching pairs of brackets, quotes, etc.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"Hoffs/omnisharp-extended-lsp.nvim",
	},

	{
		"mg979/vim-visual-multi",
	},

	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({})
			vim.api.nvim_set_keymap("n", "<leader>nt", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		-- stylua: ignore
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},

	{
		"wakatime/vim-wakatime",
		lazy = false,
	},

	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},

	{
		'mfussenegger/nvim-lint'
	}
}
