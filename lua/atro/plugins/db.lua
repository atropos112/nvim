local sql_ft = { "sql", "mysql", "plsql" }

---@type LazySpec[]
local plugins = {
	{
		"jsborjesson/vim-uppercase-sql",
		event = "VeryLazy",
	},
	{
		"tpope/vim-dadbod",
		event = "VeryLazy",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
		config = function()
			local g = vim.g
			g.db_ui_save_location = "~/.config/nvim/db/dbui"
			g.db_ui_tmp_query_location = "~/.config/nvim/db/queries"
			g.db_ui_use_nerd_fonts = true
			g.db_ui_execute_on_save = true
			g.db_ui_use_nvim_notify = true

			local autocomplete_group = vim.api.nvim_create_augroup("vimrc_autocompletion", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = sql_ft,
				callback = function()
					local cmp = require("cmp")
					local global_sources = cmp.get_config().sources
					local buffer_sources = {}

					-- add globally defined sources (see separate nvim-cmp config)
					-- this makes e.g. luasnip snippets available since luasnip is configured globally
					if global_sources then
						for _, source in ipairs(global_sources) do
							table.insert(buffer_sources, { name = source.name })
						end
					end

					-- add vim-dadbod-completion source
					table.insert(buffer_sources, { name = "vim-dadbod-completion" })

					-- update sources for the current buffer
					cmp.setup.buffer({ sources = buffer_sources })
				end,
				group = autocomplete_group,
			})
		end,
	},
}

return plugins
