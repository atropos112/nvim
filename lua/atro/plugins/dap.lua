local set = vim.keymap.set
return {
	{
		"theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"mfussenegger/nvim-dap",
		},
		opts = {},
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"williamboman/mason.nvim",
		},
		keys = {
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				mode = "n",
				desc = "Step into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				mode = "n",
				desc = "Step over",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				mode = "n",
				desc = "Continue",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				mode = "n",
				desc = "Stop debugging",
			},
		},
		config = function()
			require("dap").set_log_level("ERROR")
		end,
		-- INFO: Don't add empty opts as it will break.
	},
	{
		"Weissle/persistent-breakpoints.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local pb = require("persistent-breakpoints")
			local pb_api = require("persistent-breakpoints.api")

			pb.setup({
				load_breakpoints_event = { "BufReadPost" },
			})

			set("n", "<leader>bb", function()
				pb_api.toggle_breakpoint()
			end, { desc = "Toggle breakpoint", remap = true })
			set("n", "<leader>bc", function()
				pb_api.set_conditional_breakpoint()
			end, { desc = "Set conditional breakpoint" })
			set("n", "<leader>ba", function()
				pb_api.clear_all_breakpoints()
			end, { desc = "Clear all breakpoints" })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		event = "VeryLazy",
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			-- INFO: To see what config is available do :dapui.setup()
			dapui.setup({
				layouts = {
					{
						elements = {
							{
								id = "scopes",
								size = 0.25,
							},
							-- {
							-- 	id = "breakpoints",
							-- 	size = 0.25,
							-- },
							{
								id = "stacks",
								size = 0.25,
							},
							{
								id = "watches",
								size = 0.50,
							},
						},
						position = "left",
						size = 60,
					},
					{
						elements = {
							{
								id = "console",
								size = 0.2,
							},
							{
								id = "repl",
								size = 0.8,
							},
						},
						position = "bottom",
						size = 10,
					},
				},
				sidebar = {
					open_on_start = true,
					elements = {
						"scopes",
						"breakpoints",
						"stacks",
						"watches",
					},
					size = 40,
					position = "left",
				},
			})

			vim.keymap.set("n", "<leader>ds", function()
				dapui.open()
				dap.continue()
			end, { desc = "Start debugging" })
			vim.keymap.set("n", "<leader>dt", function()
				dap.terminate()
				dapui.close()
			end, { desc = "Stop debugging" })

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end

			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end

			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
