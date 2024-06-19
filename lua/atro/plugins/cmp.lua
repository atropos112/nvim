return {
	-- Snippets control
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
	},

	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			-- WARN: In general if possible use lint.lua for linting,
			-- fmt.lua for formatting and cmp.lua for autocompletion.
			-- Sometimes its not possible or comes with compromises.
			-- In such cases use this plugin.
			require("atro.utils.mason").install({
				"codespell",
				"impl",
				"gomodifytags",
				"staticcheck",
			})
			local null_ls = require("null-ls")

			-- INFO: List of available linters can be found here
			-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.codespell,

					-- Nix
					null_ls.builtins.diagnostics.statix,
					null_ls.builtins.diagnostics.deadnix,

					-- Go
					null_ls.builtins.code_actions.impl,
					null_ls.builtins.code_actions.gomodifytags,
					null_ls.builtins.diagnostics.staticcheck,
					null_ls.builtins.formatting.goimports,

					-- Python
					null_ls.builtins.diagnostics.mypy,
				},
			})
		end,
	},
	-- Github Copilot
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		opts = {
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<A-g>",
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
				gitcommit = true,
				gitrebase = true,
				["."] = true,
			},
		},
	},
	--- Main autocomplete plugin
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-emoji",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind.nvim",
		},
		config = function()
			--- cmp is responsible for autocomplete
			--- also load here luasnip snippets using snippets from vs-code
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")

			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.config.setup({})

			cmp.setup({
				view = {
					entries = {
						follow_cursor = true,
					},
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol", -- show only symbol annotations
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						-- can also be a function to dynamically calculate max width such as
						-- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						show_labelDetails = true, -- show labelDetails in menu. Disabled by default
					}),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					-- C-n and C-p to go back and forward in autocomplete
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					-- C-d and C-f to stroll back and forward in docs of autocomplete
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					-- Tab and Shift-Tab to go forward and backward in autocomplete just like C-n and C-p.
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "calc" },
					{ name = "tmux" },
					{ name = "emoji" },
				},
			})
		end,
	},
}
