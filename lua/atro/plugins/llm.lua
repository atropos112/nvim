---@type LazyPlugin[]
local llm_plugins = {
	-- Github Copilot
	{
		"zbirenbaum/copilot.lua",
		event = { "VeryLazy" },
		config = function()
			local keys = KEYMAPS.copilot

			require("copilot").setup({
				panel = { enabled = false },

				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = keys.accept.key, -- default
					},
				},
				filetypes = {
					yaml = true,
					help = true,
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

if CONFIG.llm_config then
	table.insert(llm_plugins, {
		"olimorris/codecompanion.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			-- I map adapter to local var as otherwise lua is not happy for some reason
			local adapter = CONFIG.llm_config.adapter
			local keymaps = KEYMAPS.llm

			local accept_change_modes = {}
			for _, mode in ipairs(keymaps.accept_suggested_change.mode) do
				accept_change_modes[mode] = keymaps.accept_suggested_change.key
			end

			local reject_change_modes = {}
			for _, mode in ipairs(keymaps.reject_suggested_change.mode) do
				reject_change_modes[mode] = keymaps.reject_suggested_change.key
			end

			LOGGER:debug("Setting up keymaps for llm plugin", {
				accept_change_modes = accept_change_modes,
				reject_change_modes = reject_change_modes,
			})

			LOGGER:info("Setting up llm plugin with adapter", { kind = CONFIG.llm_config.kind })

			require("codecompanion").setup({
				strategies = {
					chat = {
						adapter = "custom",
					},
					inline = {
						adapter = "custom",
						keymaps = {
							accept_change = {
								modes = accept_change_modes,
								description = keymaps.accept_suggested_change.description,
							},
							reject_change = {
								modes = reject_change_modes,
								description = keymaps.reject_suggested_change.description,
							},
						},
					},
				},
				adapters = {
					opts = {
						show_defaults = false,
					},
					copilot = function()
						return require("codecompanion.adapters").extend("copilot")
					end,

					custom = function()
						return require("codecompanion.adapters").extend(CONFIG.llm_config.kind, adapter)
					end,
				},
			})
		end,
	})
end

return llm_plugins
