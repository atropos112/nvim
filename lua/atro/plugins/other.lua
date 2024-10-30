local set = require("atro.utils").keyset

---@type LazySpec[]
local plugins = {
	{
		"Tastyep/structlog.nvim",
		lazy = true,
	},
	{
		"tzachar/highlight-undo.nvim",
		event = "BufRead",
		opts = {},
	},

	{
		"voxelprismatic/rabbit.nvim",
		event = "BufRead",
		version = "*", -- newest bleeding edge for them types.
		opts = {
			---@type Rabbit.Keymap
			default_keys = {
				open = { "<leader>r" },
				close = { "<Esc>", "q", "<leader>" },
				select = { "<CR>" },
				file_add = { "a" },
				file_del = { "<Del>" },
				group = { "A" },
				group_up = { "-" },
			},
		},
	},
	-- Tells you what keybindings are available
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		---@type wk.Opts
		opts = {},
	},

	-- Search for keybindings
	{
		"sudormrfbin/cheatsheet.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<C-h>", "<cmd>:Cheatsheet<CR>", desc = "NvimTree" },
		},
	},

	-- Smooth scrolling
	{
		"karb94/neoscroll.nvim",
		event = "BufRead",
		config = function()
			local neoscroll = require("neoscroll")
			neoscroll.setup({})

			local keymap = {
				["<C-u>"] = function()
					neoscroll.ctrl_u({ duration = 150 })
				end,
				["<C-d>"] = function()
					neoscroll.ctrl_d({ duration = 150 })
				end,
				["<C-b>"] = function()
					neoscroll.ctrl_b({ duration = 250 })
				end,
				["<C-f>"] = function()
					neoscroll.ctrl_f({ duration = 250 })
				end,
				["<C-y>"] = function()
					neoscroll.scroll(-0.1, { move_cursor = false, duration = 30 })
				end,
				["<C-e>"] = function()
					neoscroll.scroll(0.1, { move_cursor = false, duration = 30 })
				end,
				["zt"] = function()
					neoscroll.zt({ half_win_duration = 150 })
				end,
				["zz"] = function()
					neoscroll.zz({ half_win_duration = 150 })
				end,
				["zb"] = function()
					neoscroll.zb({ half_win_duration = 150 })
				end,
			}
			local modes = { "n", "v", "x" }
			for key, func in pairs(keymap) do
				vim.keymap.set(modes, key, func)
			end
		end,
	},
	{
		"tris203/hawtkeys.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
	},
	-- INFO: Better increase/decrease, works on versions, dates, bools etc.
	{
		"monaqa/dial.nvim",
        -- stylua: ignore
        keys = {
            { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
            { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
        },
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.constant.new({ elements = { "let", "const" } }),
					augend.constant.new({ elements = { "True", "False" } }),
				},
			})
		end,
	},
	{
		"nvim-pack/nvim-spectre",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("spectre").setup()
			set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
				desc = "Toggle Spectre",
			})
			set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
				desc = "Search current word",
			})
			set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
				desc = "Search current word",
			})
			set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
				desc = "Search on current file",
			})
		end,
	},
	{
		"jmbuhr/otter.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
	},
	{
		"OXY2DEV/helpview.nvim",
		ft = "help",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"mistweaverco/kulala.nvim",
		lazy = true,
		opts = {},
	},
	{
		"cenk1cenk2/jq.nvim",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"grapp-dev/nui-components.nvim",
		},
		opts = {},
		keys = {
			{
				"<leader>q",
				function()
					require("jq").run({
						commands = {
							{
								command = "yq",
								filetype = "yaml",
								arguments = "-r",
							},
							{
								command = "jq",
								filetype = "json",
								arguments = "-r",
							},
							{
								command = "yq",
								filetype = "yml",
								arguments = "-r",
							},
							{
								command = "xq",
								filetype = "xml",
								arguments = "-r",
							},
						},
					})
				end,
				desc = "Jq",
			},
		},
	},
	{
		"anuvyklack/hydra.nvim",
		lazy = true,
	},
	{
		"csessh/stopinsert.nvim",
		event = "VeryLazy",
		opts = {
			idle_time_ms = 1000 * 60 * 60, -- 1 hour
		},
	},
}

-- INFO: If user wants to talk to external services
if GCONF.talk_to_external == true then
	---@type LazySpec
	local wakatime_plugin = {
		"wakatime/vim-wakatime",
		event = "BufRead",
	}

	table.insert(plugins, wakatime_plugin)
end

return plugins
