---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" }, -- Can't be VeryLazy (doesn't work for some reason)
		-- Must be BufReadPre and not BufReadPost as otherwise LSP and treesitter won't load for first file.
		dependencies = {
			"ray-x/lsp_signature.nvim",
			"williamboman/mason.nvim",
			"jubnzv/virtual-types.nvim",
			"b0o/schemastore.nvim",
			"aznhe21/actions-preview.nvim",
			"nvim-telescope/telescope.nvim",
			"MysticalDevil/inlay-hints.nvim",
			"antosha417/nvim-lsp-file-operations",
		},
		config = function()
			local setup_lsp = require("atro.lsp.utils").setup_lsp

			local log = LOGGER:with({ phase = "LSP" })
			local server_names = {}
			log:info("Starting LSP setup")
			for lang, cfg in pairs(CONFIG.languages) do
				if cfg.lsps then
					for server_name, lsp_config in pairs(cfg.lsps) do
						log = log:with({ language = lang })
						log:debug("Setting up LSP: " .. server_name)
						log:trace(lsp_config)

						setup_lsp(server_name, lsp_config)
						table.insert(server_names, server_name)
					end
				else
					log:with({ language = lang }):debug("No lsps found for language")
				end
			end

			vim.lsp.enable(server_names, true)
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
