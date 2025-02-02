---@type LazyPlugin[]
return {
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {
			impersonate_nvim_cmp = true,
			debug = true,
		},
	},
	{
		"saghen/blink.cmp",
		event = { "VeryLazy" },
		dependencies = {
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
			"mikavilpas/blink-ripgrep.nvim",
			"kristijanhusak/vim-dadbod-completion",
			"folke/lazydev.nvim",
			"rcarriga/cmp-dap",
		},
		version = "*",
		config = function()
			local is_dap_buffer = require("cmp_dap").is_dap_buffer
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			require("blink.cmp").setup({

				enabled = function()
					return vim.bo.buftype ~= "prompt" or is_dap_buffer()
				end,
				snippets = { preset = "luasnip" },
				keymap = {
					preset = "super-tab",
				},
				completion = {
					accept = {
						auto_brackets = {
							enabled = true,
						},
					},

					-- Show documentation when selecting a completion item
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 100,
					},

					-- Display a preview of the selected item on the current line
					-- Obfuscated by Copilot
					ghost_text = {
						enabled = false,
					},
				},

				signature = {
					enabled = true,
				},

				appearance = {
					-- Sets the fallback highlight groups to nvim-cmp's highlight groups
					-- Useful for when your theme doesn't support blink.cmp
					-- Will be removed in a future release
					use_nvim_cmp_as_default = false,
					-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},

				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = function()
						local sql_filetypes = { mysql = true, sql = true }
						if sql_filetypes[vim.bo.filetype] ~= nil then
							return { "dadbod", "snippets", "buffer" }
						elseif is_dap_buffer() then
							return { "dap", "snippets", "buffer" }
						else
							return { "lsp", "path", "snippets", "buffer" }
						end
					end,

					providers = {
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
						},
						dadbod = {
							name = "Dadbod",
							module = "vim_dadbod_completion.blink",
							score_offset = 100,
						},
						dap = {
							name = "dap",
							module = "blink.compat.source",
							score_offset = 100,
							opts = {},
						},
					},
				},
			})
		end,
		opts_extend = { "sources.default" },
	},
	-- Snippets control
	{
		"L3MON4D3/LuaSnip",
		event = { "VeryLazy" },
		version = "v2.*",
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
}
