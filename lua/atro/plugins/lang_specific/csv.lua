if CONFIG.languages["csv"] then
	return {
		{
			"hat0uma/csvview.nvim",
			ft = "csv",
			config = function()
				local csvview = require("csvview")
				csvview.setup()

				vim.api.nvim_create_autocmd("FileType", {
					pattern = "csv",
					callback = function()
						csvview.enable()
					end,
				})
			end,
		},
	}
else
	return {}
end
