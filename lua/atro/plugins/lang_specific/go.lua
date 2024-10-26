if GCONF.languages["go"] then
	return {
		-- Debugging functionality for go
		{
			"leoluz/nvim-dap-go",
			ft = "go",
			config = function()
				-- NOTE: Debugger
				require("dap-go").setup({
					dap_configurations = {
						{
							type = "go",
							name = "Attach remote",
							mode = "remote",
							request = "attach",
						},
					},
				})
			end,
		},
		-- Golang plugin (all the lagnuage niceties in one plugin)
		{
			"fatih/vim-go",
			ft = "go",
			dependencies = {
				"mfussenegger/nvim-lint",
				"williamboman/mason.nvim",
			},
		},

		-- {
		-- 	"ray-x/go.nvim",
		-- 	dependencies = { -- optional packages
		-- 		"ray-x/guihua.lua",
		-- 		"neovim/nvim-lspconfig",
		-- 		"nvim-treesitter/nvim-treesitter",
		-- 	},
		-- 	config = function()
		-- 		require("go").setup()
		-- 	end,
		-- 	event = { "CmdlineEnter" },
		-- 	ft = { "go", "gomod" },
		-- 	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
		-- },
		-- Allows implementing interfaces
		{
			"edolphin-ydf/goimpl.nvim",
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-lua/popup.nvim" },
				{ "nvim-telescope/telescope.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
			ft = "go",
			config = function()
				require("atro.mason").ensure_installed("impl")
				require("telescope").load_extension("goimpl")
				vim.api.nvim_set_keymap("n", "<leader>im", [[<cmd>lua require'telescope'.extensions.goimpl.goimpl{}<CR>]], { noremap = true, silent = true })
			end,
		},
	}
else
	return {}
end
