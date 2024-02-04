return {
	-- Allows to comment line(s) with language understanding (different languages comment out differently)
    { 'numToStr/Comment.nvim', opts = {} },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },

	-- Theme (OneDark)
    {
        "navarasu/onedark.nvim",
        priority = 1000,
		config = function()
			require('onedark').load()
		end
    },

	--- Autocomplete
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
            'hrsh7th/cmp-nvim-lsp',
        },
    },

	-- Bottom line (with basic info)
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("lualine").setup({
                icons_enabled = true,
                theme = 'onedark',
            })
        end,
    },

	-- SYntax highlighting for programming languages
	{
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },

	-- Browsing and fuzzy finding files and dirs
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make'
    },

	-- Simplifies getting LSP servers 	
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

	-- Quickstart configs for LSPs
    "neovim/nvim-lspconfig",

    -- Full signature help, docs and completion for the nvim lua API's. 
    'folke/neodev.nvim',

	-- Golang plugin (all the lagnuage niceties in one plugin)
	'fatih/vim-go',

	-- Debugging functionality
	'mfussenegger/nvim-dap',
	'rcarriga/nvim-dap-ui',

	-- Debugging functionality for go 
	'leoluz/nvim-dap-go',

	-- Testing framework
	{
	  "nvim-neotest/neotest",
	  dependencies = {
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		--"nvim-neotest/neotest-go",
		"nvim-extensions/nvim-ginkgo",
		"nvim-neotest/neotest-python",
	  }
	},

	-- Terminal support
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		config = function()
			require("toggleterm").setup{
				open_mapping = "<leader>tt",
			}
		end
	},

	-- Github Copilot
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup{
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = "<C-CR>"
					}
				}
			}
		end
	},

	-- Undo tree i.e. a fancy "go back"  history 
	{
		"mbbill/undotree",
		config = function()
			vim.g.undotree_WindowLayout = 2
			vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle)
		end
	},

	-- File switcher 
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
        	"nvim-telescope/telescope.nvim",
		}
	},

	-- Rust support 
	{
		'mrcjkb/rustaceanvim',
		version = "^4",
		ft = { 'rust' },
	},

	-- Formatting (on save and more)
	{
		'sbdchd/neoformat',
	},


	-- Adds matching pairs of brackets, quotes, etc.
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {}
	}
}
