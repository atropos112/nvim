return {
	TalkToExternal = true,
	SupportedLanguages = {
		c = {},
		nix = {
			LSPs = { "nixd", "rnix" },
		},
		lua = {
			LSPs = { "lua_ls" },
		},
		vim = {},
		go = {
			LSPs = { "gopls" },
			TestAdapter = {
				author = "nvim-neotest",
				name = "neotest-go",
			},
			-- { "nvim-extensions/nvim-ginkgo" },
		},
		json = {
			LSPs = { "jsonls" },
		},
		python = {
			LSPs = { "basedpyright" },
			TestAdapter = {
				author = "nvim-neotest",
				name = "neotest-python",
				config = {
					justMyCode = false,
				},
			},
		},
		c_sharp = {
			LSPs = { "omnisharp" },
			TestAdapter = {
				author = "Issafalcon",
				name = "neotest-dotnet",
			},
		},
		yaml = {
			LSPs = { "yamlls" },
		},
		dockerfile = {
			LSPs = { "dockerls" },
		},
		rust = {
			TestAdapter = {
				author = "rouge8",
				name = "neotest-rust",
			},
		},
		markdown = {},
	},
}
