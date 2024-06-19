return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"jubnzv/virtual-types.nvim",
			"SmiteshP/nvim-navic",
			"b0o/schemastore.nvim",
		},
		config = function()
			-- INFO: Defining On_Attach
			local on_attach = function(client, bufnr)
				local navic_exclude = {
					"basedpyright", -- already attached to pylsp
					"rnix", -- doesn't support navic
					"pylyzer", -- already attached to pylsp
				}

				if not vim.tbl_contains(navic_exclude, client.name) then
					require("nvim-navic").attach(client, bufnr)
				end

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
				"basedpyright",
				"bash-language-server",
				"rnix-lsp",
				"lua-language-server",
				"docker-compose-language-service",
				"dockerfile-language-server",
				"nil",
				-- "gofumpt",
			})

			-- INFO: Below Are per language LSP configurations
			-- NOTE: For per-LSP config details look here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			-- Helper function that "starts the conversation"
			local function setup_lsp(server, config, skip_on_attach, skip_capabilities)
				config = config or {}
				skip_on_attach = skip_on_attach or false
				skip_capabilities = skip_capabilities or false

				if not skip_on_attach then
					config.on_attach = config.on_attach or on_attach
				end

				if not skip_capabilities then
					config.capabilities = config.capabilities or capabilities
				end

				lsp[server].setup(config)
			end

			-- INFO: Can also use :h lspconfig-all to see all available configurations
			local lang_supported = require("atro.utils.config").lang_supported
			if lang_supported("python") then
				setup_lsp("basedpyright", {
					settings = {
						basedpyright = {
							analysis = {
								autoSearchPaths = true,
								typeCheckingMode = "standard",
							},
						},
					},
				})

				setup_lsp("pylsp", {
					settings = {
						pylsp = {
							plugins = {
								pycodestyle = {
									ignore = {},
									maxLineLength = 120,
								},
								rope_completion = {
									enabled = true,
								},
								rope_autoimport = {
									enabled = true,
									completions = {
										enabled = true,
									},
									code_actions = {
										enabled = true,
									},
								},
							},
						},
					},
				})
			end

			if lang_supported("nix") then
				setup_lsp("rnix")
				setup_lsp("nixd")
				setup_lsp("nil_ls")
			end

			if lang_supported("docker") then
				setup_lsp("dockerls")
			end

			if lang_supported("zig") then
				setup_lsp("zls")
			end

			if lang_supported("bash") then
				setup_lsp("bashls")
			end

			if lang_supported("go") then
				setup_lsp("gopls", {
					settings = {
						gopls = {
							gofumpt = true,
						},
					},
					-- NOTE: go plugin take over here so should not pass capabilities or on_attach.
				}, true, false)
			end

			if lang_supported("json") then
				setup_lsp("jsonls", {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				})
			end

			if lang_supported("lua") then
				require("neodev").setup()
				setup_lsp("lua_ls", {
					{
						settings = {
							Lua = {
								workspace = { checkThirdParty = false },
								telemetry = { enable = false },
							},
						},
					},
				})
			end

			if lang_supported("csharp") then
				-- INFO: Is covered partially be the omnisharp plugin (look at csharp specific config file for details)
				setup_lsp("omnisharp", {}, false, true)
			end

			if lang_supported("yaml") then
				setup_lsp("yamlls", {
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
			end
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
}
