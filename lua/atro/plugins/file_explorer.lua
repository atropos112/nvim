---@type LazySpec[]
return {
	{
		"s1n7ax/nvim-window-picker",
		name = "window-picker",
		event = "VeryLazy",
		version = "2.*",
		config = function()
			require("window-picker").setup()
		end,
	},

	-- Section: Plugin to show the top bar. Showing file path with respect to root but also where in that file we
	-- are object wise (i.e. tells you which function you are or which class or which list).
	{
		"Bekaboo/dropbar.nvim",
		event = { "VeryLazy" },
		dependencies = {
			-- optional, but required for fuzzy finder support
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			local dropbar_api = require("dropbar.api")
			local dropbar = require("dropbar")

			dropbar.setup(
				---@class dropbar_configs_t
				{
					sources = {
						path = {
							max_depth = 8,
						},
						treesitter = {
							-- treesitter is a bit too much for me.
							max_depth = 0,
						},
						lsp = {
							-- How deep to look into objects inside of a file.
							-- 3 seems like a lot already so I'm keeping it at 3.
							max_depth = 3,
							valid_symbols = {
								"File",
								"Module",
								"Namespace",
								"Package",
								"Class",
								"Method",
								"Property",
								"Field",
								"Constructor",
								"Enum",
								"Interface",
								"Function",
								"Variable",
								"Constant",
								"String",
								"Number",
								"Boolean",
								"Array",
								"Object",
								"Keyword",
								"Null",
								"EnumMember",
								"Struct",
								"Event",
								"Operator",
								"TypeParameter",
							},
							request = {
								-- Times to retry a request before giving up
								ttl_init = 60,
								interval = 1000, -- in ms
							},
						},
						markdown = {
							max_depth = 6,
							parse = {
								-- Number of lines to update when cursor moves out of the parsed range
								look_ahead = 200,
							},
						},
						terminal = {
							---@type string|fun(buf: integer): string
							icon = function(_)
								return M.opts.icons.kinds.symbols.Terminal or " "
							end,
							---@type string|fun(buf: integer): string
							name = vim.api.nvim_buf_get_name,
							---@type boolean
							---Show the current terminal buffer in the menu
							show_current = true,
						},
					},
				}
			)
			KEYMAPS:set(KEYMAPS.file_exploration.show_top_bar_keys, dropbar_api.pick)

			vim.ui.select = require("dropbar.utils.menu").select
		end,
	},
	-- Section: Plugin that adds support for file operations using built-in LSP support. Adding support for
	-- workspace/WillRename
	-- workspace/DidRename
	-- workspace/WillCreate
	-- workspace/DidCreate
	-- workspace/WillDelete
	-- workspace/DidDelete
	{
		"antosha417/nvim-lsp-file-operations",
		lazy = true, -- Will be loaded in get capabilities in LSP setup.
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			local opts = {
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
			}

			require("lsp-file-operations").setup(opts)
		end,
	},

	-- Section: A file explorer plugin, shows directories, allows you to open files, etc.
	-- Also shows git state and with nvim-lsp-file-operations you can rename, delete, etc.
	-- and for it to take affect in the file system where it "should".
	{
		"neo-tree.nvim",
		branch = "v3.x",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
		config = function()
			local opts = {
				enable_git_status = require("atro.utils").is_git_dir(),
				close_if_last_window = true,
				popup_border_style = "rounded",
				sort_case_insensitive = true,

				source_selector = {
					winbar = false,
					show_scrolled_off_parent_node = true,
					padding = { left = 1, right = 0 },
					sources = {
						{ source = "filesystem", display_name = "  Files" }, --      
						{ source = "buffers", display_name = "  Buffers" }, --      
						{ source = "git_status", display_name = " 󰊢 Git" }, -- 󰊢      
					},
				},

				default_component_configs = {
					indent = {
						with_expanders = false,
					},
					icon = {
						folder_empty = "",
						folder_empty_open = "",
						default = "",
					},
					modified = {
						symbol = "•",
					},
					name = {
						trailing_slash = true,
						highlight_opened_files = true,
						use_git_status_colors = true,
					},
					git_status = {
						symbols = {
							-- Change type
							added = "A",
							deleted = "D",
							modified = "M",
							renamed = "R",
							-- Status type
							untracked = "U",
							ignored = "I",
							unstaged = "",
							staged = "S",
							conflict = "C",
						},
					},
				},

				filesystem = {
					bind_to_cwd = true,
					follow_current_file = { enabled = true },
					find_by_full_path_words = true,
					group_empty_dirs = true,
					use_libuv_file_watcher = true,

					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = true,
						hide_by_name = {
							".git",
							".hg",
							".svc",
							".DS_Store",
							"thumbs.db",
							".sass-cache",
							"node_modules",
							".pytest_cache",
							".mypy_cache",
							"__pycache__",
							".stfolder",
							".stversions",
						},
						never_show_by_pattern = {
							"vite.config.js.timestamp-*",
						},
					},
				},
				buffers = {},
				git_status = {},
				document_symbols = {
					follow_cursor = true,
				},
			}

			require("neo-tree").setup(opts)

			KEYMAPS:set(KEYMAPS.file_exploration.toggle_file_explorer, function()
				require("neo-tree.command").execute({ toggle = true, reveal = true, dir = vim.uv.cwd() })
			end)
		end,
	},
}
