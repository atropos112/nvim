local defaults = {
	TalkToExternal = true,
	SupportedLanguages = {
		sql = {
			LSPs = { "sqlls" },
		},
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

-- No assumption is made as to if there are overrides or not, the file might be missing.
local overrides = {}
if require("atro.utils.generic").file_exists(vim.fn.stdpath("config") .. "/lua/atro/configs/user_cfg_overrides.lua") then
	overrides = require("atro.configs.user_cfg_overrides")
end

-- Apply overrides
_G.user_conf = require("atro.utils.generic").merge_tables_at_root(defaults, overrides)
