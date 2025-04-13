local dict_path = os.getenv("HOME") .. "/.local/share/nvim/dict.txt"

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
			impersonate_nvim_cmp = false,
			debug = false,
		},
	},
	{
		"Kaiser-Yang/blink-cmp-dictionary",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		lazy = true,
		config = function()
			-- If there is no dictionary get it.
			if vim.fn.filereadable(dict_path) == 0 or vim.fn.getftime(dict_path) < os.time() - 86400 then
				vim.fn.system("wget -q -O " .. dict_path .. " https://raw.githubusercontent.com/dwyl/english-words/refs/heads/master/words_alpha.txt")
				LOGGER:with({ dict_path = dict_path }):info("Downloaded dictionary, a one time operation")
			end
		end,
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
			"xzbdmw/colorful-menu.nvim",
			"mikavilpas/blink-ripgrep.nvim",
			"Kaiser-Yang/blink-cmp-dictionary",
		},
		version = "*",
		config = function()
			local is_dap_buffer = require("cmp_dap").is_dap_buffer
			local log = LOGGER:with({ phase = "CMP" })

			local sql_filetypes = { mysql = true, sql = true }

			-- Computing sources here rather than later so I can log.
			local sources = { "snippets", "buffer", "dictionary" }

			-- TODO: This won't work after file is loaded. need to do per file or other way.
			if sql_filetypes[vim.bo.filetype] ~= nil then
				sources = { "dadbod" } -- I dont want anything else there
			elseif is_dap_buffer() then
				sources = vim.list_extend(sources, { "dap", "ripgrep", "path" })
			elseif require("atro.utils").is_git_dir() then
				-- ripgrep slows stuff down if the project is big, limiting to git repos only.
				sources = vim.list_extend(sources, { "lsp", "ripgrep", "path" })
			else
				sources = vim.list_extend(sources, { "lsp", "path" })
			end

			log:with({ sources = sources }):info("Enabled CMP sources")

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
					menu = {
						draw = {
							-- We don't need label_description now because label and label_description are already
							-- combined together in label by colorful-menu.nvim.
							columns = { { "kind_icon" }, { "label", gap = 1 } },
							components = {
								label = {
									text = function(ctx)
										return require("colorful-menu").blink_components_text(ctx)
									end,
									highlight = function(ctx)
										return require("colorful-menu").blink_components_highlight(ctx)
									end,
								},
							},
						},
					},

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
					default = sources,
					per_filetype = {
						sql = { "dadbod" },
						codecompanion = { "codecompanion" },
					},

					providers = {
						dictionary = {
							module = "blink-cmp-dictionary",
							name = "Dict",
							min_keyword_length = 4, -- has to be at least 2
							opts = {
								dictionary_files = { dict_path },
							},
							score_offset = 50,
						},
						ripgrep = {
							module = "blink-ripgrep",
							name = "Ripgrep",
							---@module "blink-ripgrep"
							---@type blink-ripgrep.Options
							opts = {
								--  The number of lines to show around each match in the preview (documentation) window. For example, 5 means to show 5 lines before, then the match, and another 5 lines after the match.
								context_size = 50,

								-- The maximum file size that ripgrep should include in its search. Examples: "1024" (bytes by default), "200K", "1M", "1G"
								max_filesize = "1M",
							},
							score_offset = 51,
						},
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 101,
						},
						dadbod = {
							name = "Dadbod",
							module = "vim_dadbod_completion.blink",
							score_offset = 102,
						},
						dap = {
							name = "dap",
							module = "blink.compat.source",
							score_offset = 103,
							opts = {},
						},
						lsp = {
							name = "LSP",
							module = "blink.cmp.sources.lsp",
							score_offset = 200,
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
		event = { "VeryLazy" },
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
		event = { "VeryLazy" },
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
	{
		"xzbdmw/colorful-menu.nvim",
		lazy = true,
		opts = {},
	},
}
