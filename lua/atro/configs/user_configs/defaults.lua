return {
	TalkToExternal = true,
	SupportedLanguages = {
		bash = {
			LSPs = { "bashls" },
		},
		c = {},
		toml = {
			LSPs = { "taplo" },
		},
		nix = {
			LSPs = { "nixd" },
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
			LSPs = { "pylsp", "basedpyright" },
			TestAdapter = {
				author = "nvim-neotest",
				name = "neotest-python",
				config = {
					justMyCode = false,
				},
			},
			DAP = {
				-- that's where Mason will drop it
				path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
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
