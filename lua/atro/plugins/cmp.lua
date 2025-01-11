local log = LOGGER:with({ phase = "CMP" })

local cmp_deps = function()
	if _G.cmp_deps then
		return _G.cmp_deps
	end

	-- Using https://github.com/iguanacucumber/magazine.nvim a soft fork of nvim-cmp with perf improvements etc.
	local deps = {
		{
			"iguanacucumber/mag-nvim-lsp",
			name = "cmp-nvim-lsp",
			opts = {},
		},
		{
			"iguanacucumber/mag-nvim-lua",
			name = "cmp-nvim-lua",
		},
		{
			"iguanacucumber/mag-buffer",
			name = "cmp-buffer",
		},
		{
			"iguanacucumber/mag-cmdline",
			name = "cmp-cmdline",
		},

		"hrsh7th/cmp-path",
		"hrsh7th/cmp-calc",

		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
		"rcarriga/cmp-dap",
	}

	log:debug("Constructing cmp dependencies: " .. vim.inspect(deps))

	_G.cmp_deps = deps
	return deps
end

return {
	{
		"https://codeberg.org/FelipeLema/cmp-async-path",
		event = "VeryLazy",
	},
	-- Snippets control
	{
		"L3MON4D3/LuaSnip",
		event = "BufRead",
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
			local null_ls = require("null-ls")

			null_ls.setup({ sources = CONFIG.null_ls_sources or {} })
		end,
	},
	-- Github Copilot
	{
		"zbirenbaum/copilot.lua",
		event = "VeryLazy",
		config = function()
			local keys = KEYMAPS.copilot

			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = keys.accept.key, -- default
					},
				},
				filetypes = {
					yaml = true,
					markdown = true,
					gitcommit = true,
					gitrebase = true,
					["."] = true,
				},
			})

			KEYMAPS:set(keys.accept_mac, require("copilot.suggestion").accept)
		end,
	},
	--- Main autocomplete plugin
	{
		"iguanacucumber/magazine.nvim",
		name = "nvim-cmp", -- Otherwise highlighting gets messed up
		event = "VeryLazy",
		dependencies = cmp_deps(),
		config = function()
			--- cmp is responsible for autocomplete
			--- also load here luasnip snippets using snippets from vs-code
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")

			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.config.setup({})

			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})

			local sources = {
				{ name = "lazydev" },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer" },
				{ name = "calc" },
				{ name = "tmux" },
				{ name = "nvim_lua" },
			}

			---@type cmp.Setup
			cmp.setup({
				view = {
					entries = {
						follow_cursor = true,
					},
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol", -- show only symbol annotations
						maxwidth = 70, -- prevent the popup from showing more than provided characters (e.g 70 will not show more than 50 characters)
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
				sources = sources,
			})

			--- INFO: For cmp for dap
			---
			cmp.setup({
				enabled = function()
					return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
				end,
			})

			cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
				sources = {
					{ name = "dap" },
				},
			})
		end,
	},
}
