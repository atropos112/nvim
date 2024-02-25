vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.typ",
	callback = function(args)
		vim.api.nvim_buf_set_option(args.buf, "filetype", "typst")
	end,
})

return {
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "0.1.*",
		build = function()
			require("typst-preview").update()
		end,
		opts = {},
	},
}
