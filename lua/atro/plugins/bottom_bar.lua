return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"linrongbin16/lsp-progress.nvim",
			"folke/noice.nvim",
			"AndreM222/copilot-lualine",
		},
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				icons_enabled = true,
				theme = "catppuccin",
				sections = {
					lualine_a = {},
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						-- invoke `progress` here.
						require("lsp-progress").progress,
					},
					lualine_x = {
						{
							require("noice").api.statusline.mode.get,
							cond = require("noice").api.statusline.mode.has,
							color = { fg = "#ff9e64" },
						},
					},
					lualine_y = { "progress", "location" },

					lualine_z = { "copilot" },
					-- lualine_z = { "location" },
				},
			})

			-- listen lsp-progress event and refresh lualine
			vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
			vim.api.nvim_create_autocmd("User", {
				group = "lualine_augroup",
				pattern = "LspProgressStatusUpdated",
				callback = require("lualine").refresh,
			})
		end,
	},
	{
		"linrongbin16/lsp-progress.nvim",
		event = "LspAttach",
		config = function()
			require("lsp-progress").setup({
				client_format = function(client_name, spinner, series_messages)
					if #series_messages == 0 then
						return nil
					end
					return {
						name = client_name,
						body = spinner .. " " .. table.concat(series_messages, ", "),
					}
				end,
				format = function(client_messages)
					--- @param name string
					--- @param msg string?
					--- @return string
					local function stringify(name, msg)
						return msg and string.format("%s %s", name, msg) or name
					end

					local sign = "" -- nf-fa-gear \uf013
					local lsp_clients = vim.lsp.get_clients()
					local messages_map = {}
					for _, climsg in ipairs(client_messages) do
						messages_map[climsg.name] = climsg.body
					end

					if #lsp_clients > 0 then
						table.sort(lsp_clients, function(a, b)
							return a.name < b.name
						end)
						local builder = {}
						for _, cli in ipairs(lsp_clients) do
							if type(cli) == "table" and type(cli.name) == "string" and string.len(cli.name) > 0 and cli.name ~= "copilot" then
								if messages_map[cli.name] then
									table.insert(builder, stringify(cli.name, messages_map[cli.name]))
								else
									table.insert(builder, stringify(cli.name))
								end
							end
						end
						if #builder > 0 then
							return sign .. " " .. table.concat(builder, ", ")
						end
					end
					return ""
				end,
			})
		end,
		dependencies = {
			"nvim-lualine/lualine.nvim",
		},
	},
}
