return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"jubnzv/virtual-types.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			-- INFO: Defining On_Attach
			local on_attach = function(_, bufnr)
				local set = require("atro.utils.generic").keyset

				local opts = { noremap = true, silent = true }
				opts.buffer = bufnr

				-- set keybinds
				opts.desc = "Show LSP references"
				set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
				require("virtualtypes").on_attach()
			end

			-- INFO: Defining Capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			local lsp = require("lspconfig")

			-- INFO: Using my own utils function instead of mason-lspconfig as it checks if the stuff is already installed
			-- outside of mason. This is useful for NixOS setup where mason version just doesn't work sometimes due to libc issues.
			require("atro.utils.mason").install({
				"python-lsp-server",
				"bash-language-server",
				"rnix-lsp",
				"lua-language-server",
				"docker-compose-language-service",
				"nil",
			})

			-- INFO: Below Are per language LSP configurations
			-- NOTE: For per-LSP config details look here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			lsp.pylsp.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = {
								ignore = {},
								maxLineLength = 120,
							},
						},
					},
				},
			})

			lsp.bashls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lsp.rnix.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lsp.nil_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- NOTE: go plugin take over here so should not pass capabilities or on_attach.
			lsp.gopls.setup({
				capabilities = capabilities,
			})

			lsp.jsonls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			require("neodev").setup()
			lsp.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			-- INFO: Is covered partially be the csharp plugin (look at csharp specific config file for details)
			lsp.omnisharp.setup({
				on_attach = on_attach,
			})

			lsp.yamlls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					yaml = {
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas({
							extra = {
								url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
								name = "Argo CD Application",
								fileMatch = "argocd-application.yaml",
							},
						}),
					},
				},
			})
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

	-- Multi-line <-> Single-line toogling
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
}
