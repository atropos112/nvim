local set = require("atro.utils.generic").keyset

---@type LazySpec[]
local plugins = {
	{
		"tzachar/highlight-undo.nvim",
		event = "BufRead",
		opts = {},
	},

	{
		"voxelprismatic/rabbit.nvim",
		event = "BufRead",
		opts = {
			colors = {}, -- defaults
			window = {
				title = "Rabbit",
				plugin_name_position = "bottom",
				emphasis_width = 8,
				width = 64,
				height = 24,
				float = {
					"bottom",
					"right",
				},
				split = "right",
				overflow = ":::",
				path_len = 12,
			},
			default_keys = {
				close = { "<Esc>", "q", "<leader>" },
				select = { "<CR>" },
				open = { "<leader>rr" },
				file_add = { "a" },
				file_del = { "<Del>" },
				group = { "A" },
				group_up = { "-" },
			},
			plugin_opts = {},
			enable = {
				"history",
				"reopen",
				"oxide",
				"harpoon",
			},
		},
	},
	-- API info of vim

	-- Downloads dependencies for LSP, formatter and debugger
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"zapling/mason-lock.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-lock").setup({
				lockfile_path = vim.fn.stdpath("config") .. "/mason-lock.json", -- (default)
			})
		end,
	},

	-- Tells you what keybindings are available
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			triggers_blacklist = {
				n = { "d", "y" },
			},
		},
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
		config = function()
			require("neoscroll").setup({})

			local t = {}
			-- Syntax: t[keys] = {function, {function arguments}}
			t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "150" } }
			t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "150" } }
			t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250" } }
			t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250" } }
			t["<C-y>"] = { "scroll", { "-0.10", "false", "30" } }
			t["<C-e>"] = { "scroll", { "0.10", "false", "30" } }
			t["zt"] = { "zt", { "150" } }
			t["zz"] = { "zz", { "150" } }
			t["zb"] = { "zb", { "150" } }

			require("neoscroll.config").set_mappings(t)
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
				},
			})
		end,
	},
	{
		"nvim-pack/nvim-spectre",
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
}

if _G.user_conf.TalkToExternal == true then
	---@type LazySpec
	local wakatime_plugin = {
		"wakatime/vim-wakatime",
		event = "BufRead",
	}

	table.insert(plugins, wakatime_plugin)
end

return plugins
