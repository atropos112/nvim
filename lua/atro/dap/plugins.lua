local M = {}

M.dap_plugins_and_load = function()
	if _G._dap_plugins then
		return _G._dap_plugins
	end

	local langSupported = require("atro.utils.config").IsLangSupported
	local set = vim.keymap.set
	local dap_configs = require("atro.dap.configs").dap_configs()
	local install = require("atro.installer.installer").ensure_installed

	-- NOTE: When loading dap configurations for a given language we either:
	-- - Load it via plugin.
	-- - Load it in the "mfussenegger/nvim-dap" config section by loading configs from atro.dap.configs.dap_configs(), we also install the adapter if needed.
	--
	---@type LazySpec[]
	_G._dap_plugins = {
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
				local dap = require("dap")
				dap.set_log_level("ERROR")

				-- INFO: Loading dap configs by loading from atro.dap.configs.dap_configs()
				for lang, config in pairs(dap_configs) do
					if config.adapters then
						for adapter, adapter_config in pairs(config.adapters) do
							dap.adapters[adapter] = adapter_config
						end
					end
					if config.configs then
						dap.configurations[lang] = config.configs
					end
				end
			end,
		},
		{
			"Weissle/persistent-breakpoints.nvim",
			event = "BufRead",
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
			"lucaSartore/nvim-dap-exception-breakpoints",
			event = "VeryLazy",
			dependencies = { "mfussenegger/nvim-dap" },

			config = function()
				local set_exception_breakpoints = require("nvim-dap-exception-breakpoints")

				vim.api.nvim_set_keymap("n", "<leader>dy", "", { desc = "[D]ebug [C]ondition breakpoints", callback = set_exception_breakpoints })
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

	-- INFO:Loading dap configs via plugins here:
	if langSupported("python") then
		table.insert(_G._dap_plugins, {
			"mfussenegger/nvim-dap-python",
			ft = "python",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
			config = function()
				local dappy = require("dap-python")
				local dap_path = require("atro.dap.configs").dap_configs().python.debugpy_python_path

				if dap_path then
					dappy.setup(dap_path)
				else
					-- Trying to use the "python" we have in the path might not work if no debugpy there
					dappy.setup("python")
				end

				dappy.test_runner = "pytest"
			end,
		})
	end

	return _G._dap_plugins
end

return M
