return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"jubnzv/virtual-types.nvim",
			"SmiteshP/nvim-navic",
			"sontungexpt/better-diagnostic-virtual-text",
		},
		config = function()
			-- INFO: Defining On_Attach
			local on_attach = function(client, bufnr)
				local navic_exclude = {
					"pylsp", -- already attached to basedpyright
					"rnix", -- doesn't support navic
				}
				local lsp = vim.lsp

				-- nil can replace with the options of each buffer
				require("better-diagnostic-virtual-text.api").setup_buf(bufnr, nil)

				lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
					border = "single",
					focusable = false,
					relative = "cursor",
				})

				require("inlay-hints").on_attach(client, bufnr)

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

			-- INFO: Using my own utils function instead of mason-lspconfig as it checks if the stuff is already installed
			-- outside of mason. This is useful for NixOS setup where mason version just doesn't work sometimes due to libc issues.
			local ensure_lsp_installed = require("atro.utils.mason").install

			local lsp = require("lspconfig")

			-- INFO: This provides a way to streamline LSP loading.
			-- The settings can contain the following:
			-- skip_on_attach: boolean - if true, will not attach on_attach function
			-- skip_capabilities: boolean - if true, will not attach capabilities
			-- mason_name: string - the name of the mason package to install if not already installed.
			-- If not provided will attempt to install using the lsp name, this only installs if the binary is not found.
			-- This is only used if skip_install is not true.
			-- skip_install: boolean - if true, will not attempt to install the mason package (regardless if binary exists or not).
			--
			-- INFO: The keys above are removed in the process from the settings table and what is left is passed to the lsp setup function.
			local function setup_lsp(server, settings)
				settings = settings or {}

				-- skip's
				local skip_on_attach = settings.skip_on_attach or false
				settings.skip_on_attach = nil -- remove the key

				local skip_capabilities = settings.skip_capabilities or false
				settings.skip_capabilities = nil

				-- mason install
				local skip_install = settings.skip_install or false
				if not skip_install then
					ensure_lsp_installed(settings.mason_name or server)
					settings.mason_name = nil
				end

				-- Alternative server name (optional)
				local server_name = settings.server_name or server
				settings.server_name = nil

				-- create lsp settings
				local lsp_settings = {
					settings = {},
				}

				-- By now settings should only have the LSP specific settings not any special keys of mine.
				lsp_settings.settings[server_name] = settings or {}

				if not skip_on_attach then
					lsp_settings.on_attach = settings.on_attach or on_attach
				end

				if not skip_capabilities then
					lsp_settings.capabilities = settings.capabilities or capabilities
				end

				lsp[server].setup(lsp_settings)
			end

			-- INFO: Can also use :h lspconfig-all to see all available configurations
			-- INFO: Below Are per language LSP configurations
			-- NOTE: For per-LSP config details look here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			-- NOTE: below lsp_config dictionary is used in tandem with the setup_lsp function above which conceals a lot of complexity.
			-- Here is an example of usage, suppose your typical lsp setup looks like this:
			-- lsp.pylsp.setup({
			-- 	on_attach = on_attach,
			-- 	capabilities = capabilities,
			-- 	settings = {
			-- 		pylsp = {
			-- 			plugins = {
			-- 				pycodestyle = {
			-- 					ignore = {},
			-- 					maxLineLength = 120,
			-- 				},
			-- 			},
			-- 		},
			-- 	},
			-- })
			-- This would translate to having an entry in lsp_configs blow that looks like:
			-- lsp_configs = {
			-- 	pylsp = {
			-- 		mason_name = "python-lsp-server",
			--  	skip_capabilities = false,
			-- 		plugins = {
			-- 			pycodestyle = {
			-- 				ignore = {},
			-- 				maxLineLength = 120,
			-- 			},
			-- 		},
			-- 	},
			-- }
			-- where mason_name is typically not needed but necessary for pylsp as it has a different mason name to its lsp name.
			-- here skip_capabilities (and skip_on_attach) is set to false by default and is shown above just for demonsrtation purposes.
			local lsp_configs = {
				basedpyright = {
					analysis = {
						autoSearchPaths = true,
						typeCheckingMode = "standard",
						useLibraryCodeForTypes = true,
					},
				},

				pylsp = {
					mason_name = "python-lsp-server",
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

				rnix = {
					mason_name = "rnix-lsp",
				},

				nixd = {
					skip_install = true,
					diagnostic = {
						suppress = { "sema-escaping-with" },
					},
				},

				nil_ls = {
					mason_name = "nil",
				},

				dockerls = {
					mason_name = "dockerfile-language-server",
				},

				zls = {},

				bashls = {
					mason_name = "bash-language-server",
				},

				gopls = {
					gofumpt = true,
					-- NOTE: go plugin take over here so should not pass on_attach.
					skip_on_attach = true,
				},

				jsonls = {
					mason_name = "json-lsp",
				},

				lua_ls = {
					mason_name = "lua-language-server",
				},

				omnisharp = {
					skip_capabilities = true,
				},

				yamlls = {
					skip_install = true,
				},
			}

			for _, v in ipairs(require("atro.utils.config").SelectedLSPs()) do
				if lsp_configs[v] then
					setup_lsp(v, lsp_configs[v])
				else
					error("LSP not configured: " .. v)
				end
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
	{
		"MysticalDevil/inlay-hints.nvim",
		event = "LspAttach",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("inlay-hints").setup()
		end,
	},
}
