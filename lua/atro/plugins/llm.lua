---@type LazyPlugin[]
local llm_plugins = {}

--- Depending if we want to use copilot or supermaven for auto-completion
--- we need to install the correct plugin.
if CONFIG.auto_complete_type then
	LOGGER:info("Auto-completion type set", { type = CONFIG.auto_complete_type })
	if CONFIG.auto_complete_type == AutoCompleteType.copilot then
		-- Github Copilot
		table.insert(
			llm_plugins,
			-- Github Copilot
			{
				"zbirenbaum/copilot.lua",
				event = { "VeryLazy" },
				config = function()
					local keys = KEYMAPS.auto_complete_llm
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
			}
		)
	elseif CONFIG.auto_complete_type == AutoCompleteType.supermaven then
		-- SuperMaven
		table.insert(
			llm_plugins,
			-- SuperMaven
			{
				"supermaven-inc/supermaven-nvim",
				config = function()
					local keys = KEYMAPS.auto_complete_llm
					require("supermaven-nvim").setup({
						keymaps = {
							accept_suggestion = keys.accept.key, -- default
						},
					})
				end,
			}
		)
	end
end

if CONFIG.llm_config then
	LOGGER:info("Adding code companion plugin", { config = CONFIG.llm_config })
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
