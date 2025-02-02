---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" }, -- Can't be VeryLazy (doesn't work for some reason)
		dependencies = {
			"williamboman/mason.nvim",
			"jubnzv/virtual-types.nvim",
			"b0o/schemastore.nvim",
			"aznhe21/actions-preview.nvim",
			"nvim-telescope/telescope.nvim",
			"MysticalDevil/inlay-hints.nvim",
			"antosha417/nvim-lsp-file-operations",
		},
		config = function()
			local lsp = require("lspconfig")
			local setup_lsp = require("atro.lsp.utils").setup_lsp

			local log = LOGGER:with({ phase = "LSP" })
			log:info("Starting LSP setup")
			for lang, cfg in pairs(CONFIG.languages) do
				if cfg.lsps then
					for server_name, lsp_config in pairs(cfg.lsps) do
						log = log:with({ language = lang })
						log:debug("Setting up LSP: " .. server_name)
						log:trace(lsp_config)

						lsp = setup_lsp(server_name, lsp_config, lsp)
					end
				else
					log:with({ language = lang }):debug("No lsps found for language")
				end
			end
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			require("lsp-file-operations").setup({
				-- used to see debug logs in file `vim.fn.stdpath("cache") .. lsp-file-operations.log`
				debug = false,
				-- select which file operations to enable
				operations = {
					willRenameFiles = true,
					didRenameFiles = true,
					willCreateFiles = true,
					didCreateFiles = true,
					willDeleteFiles = true,
					didDeleteFiles = true,
				},
				-- how long to wait (in milliseconds) for file rename information before cancelling
				timeout_ms = 10000,
			})
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

	{
		"MysticalDevil/inlay-hints.nvim",
		event = "LspAttach",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("inlay-hints").setup()
		end,
	},
}
