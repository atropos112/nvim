if require("atro.utils.config").IsLangSupported("python") then
	return {
		{
			"roobert/f-string-toggle.nvim",
			ft = "python",
			opts = {
				key_binding = "<leader>f",
				key_binding_desc = "Toggle f-string",
			},
		},
	}
else
	return {}
end
