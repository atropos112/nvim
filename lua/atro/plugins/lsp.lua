---@type LazySpec[]
local plugins = {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"jubnzv/virtual-types.nvim",
			"SmiteshP/nvim-navic",
			"sontungexpt/better-diagnostic-virtual-text",
			"b0o/schemastore.nvim",
		},
		config = function()
			require("atro.utils.lsp").setup_lsps()
		end,
	},

	-- Shows where you are in the file LSP wise (which class/function etc)
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},

	-- Multi-line <-> Single-line toggling
	{
		"Wansmer/treesj",
		keys = { "<space>m", "<leader>M" },
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
			})
			vim.keymap.set("n", "<leader>m", require("treesj").toggle)
			vim.keymap.set("n", "<leader>M", function()
				require("treesj").toggle({ split = { recursive = true } })
			end)
		end,
	},

	-- Show LSP explorer of functions and classes etc.
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {},
	},
	{
		"MysticalDevil/inlay-hints.nvim",
		event = "LspAttach",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("inlay-hints").setup()
		end,
	},
	{
		"sontungexpt/better-diagnostic-virtual-text",
		event = "LspAttach",
		opts = {
			inline = false,
			ui = {
				above = true,
			},
		},
	},
}

return plugins
