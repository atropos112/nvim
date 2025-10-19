if CONFIG.languages["go"] then
	return {
		-- Section: deep-completion source for unimported packages. Completes unimported packages as you type which go for some reason does not do by default.
		{
			"samiulsami/cmp-go-deep",
			dependencies = { "kkharji/sqlite.lua" },
		},
		-- Section: Providing configurations for launching go debugger (delve) and debugging individual tests.
		-- Looks like bunch of nvim-dap configurations that can be done manually but this plugin does it for you.
		{
			"leoluz/nvim-dap-go",
			ft = "go",
			lazy = true,
			opts = {},
		},
	}
else
	return {}
end
