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
