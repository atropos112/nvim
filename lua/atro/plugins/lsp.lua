---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		event = "BufRead",
		dependencies = {
			"williamboman/mason.nvim",
			"jubnzv/virtual-types.nvim",
			"SmiteshP/nvim-navic",
			"b0o/schemastore.nvim",
		},
		config = function()
			local lsp = require("lspconfig")
			local setup_lsp = require("atro.lsp.utils").setup_lsp

			for _, cfg in pairs(GCONF.languages) do
				if cfg.lsps then
					for server_name, lsp_config in pairs(cfg.lsps) do
						lsp = setup_lsp(server_name, lsp_config, lsp)
					end
				end
			end
		end,
	},

	-- Shows where you are in the file LSP wise (which class/function etc)
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
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
		event = "LspAttach",
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
}
