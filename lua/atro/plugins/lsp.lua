---@type LazySpec[]
return {
	-- Section::  Quickstart configs for Nvim LSP.
	{
		"neovim/nvim-lspconfig",
		-- INFO: If you load any time later than BufReadPre/BufNewFile the LSP and treesitter won't start for the first opened file.
		-- This is quiet heavy as it loads stuff like treesitter, lsp plugins etc. so best to start as late as possible. Currently
		-- startup time is ~50ms, with this in startup it would be around ~110ms.
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim", -- Downloads LSP servers if missing, needs to happen before lspconfig
			"b0o/schemastore.nvim", -- JSON schemas to provide better json/yaml checks
			"aznhe21/actions-preview.nvim",
			"nvim-telescope/telescope.nvim",
			"antosha417/nvim-lsp-file-operations",
		},
		config = function()
			local parse_user_lsp_config = require("atro.lsp.utils").parse_user_lsp_config
			local log = LOGGER:with({ phase = "LSP" })
			log:info("Starting LSP setup")
			for lang, cfg in pairs(CONFIG.languages) do
				if cfg.lsps then
					for server_name, user_lsp_config in pairs(cfg.lsps) do
						log = log:with({ language = lang })
						log:debug("Setting up LSP: " .. server_name)
						local lsp_config = parse_user_lsp_config(user_lsp_config)
						log:trace(lsp_config)

						vim.lsp.config(server_name, lsp_config)
						vim.lsp.enable(server_name, true)
					end
				else
					log:with({ language = lang }):debug("No lsps found for language")
				end
			end
		end,
	},

	-- Section: Plugin that allows Multi-line <-> Single-line toggling
	{
		"Wansmer/treesj",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local keys = KEYMAPS.split_join
			local sj = require("treesj")

			sj.setup({
				use_default_keymaps = false,
			})
			KEYMAPS:set_many({
				{ keys.toggle_split_join, sj.toggle },
				{
					keys.toggle_split_join_recursive,
					function()
						sj.toggle({ split = { recursive = true } })
					end,
				},
			}, { noremap = true, silent = true })
		end,
	},

	-- Section: Plugin that uses LSP to show inlay hints in all LSP servers that support it
	{
		"MysticalDevil/inlay-hints.nvim",
		event = "LspAttach",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},
}
