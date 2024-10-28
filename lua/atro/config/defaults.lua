require("atro.config.types")

---@type GlobalConfig
return {
	mason_config = {},
	null_ls_sources = {},
	git_linker_callbacks = function()
		return {
			["github.com"] = require("gitlinker.hosts").get_github_type_url,
			["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
			["try.gitea.io"] = require("gitlinker.hosts").get_gitea_type_url,
			["codeberg.org"] = require("gitlinker.hosts").get_gitea_type_url,
			["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
			["try.gogs.io"] = require("gitlinker.hosts").get_gogs_type_url,
			["git.sr.ht"] = require("gitlinker.hosts").get_srht_type_url,
			["git.launchpad.net"] = require("gitlinker.hosts").get_launchpad_type_url,
			["repo.or.cz"] = require("gitlinker.hosts").get_repoorcz_type_url,
			["git.kernel.org"] = require("gitlinker.hosts").get_cgit_type_url,
			["git.savannah.gnu.org"] = require("gitlinker.hosts").get_cgit_type_url,
		}
	end,
	logging = {
		consol_log_level = LogLevel.ERROR,
		file_log_level = LogLevel.DEBUG,
	},
	log_level = "DEBUG",
	talk_to_external = true,
	global_linters = { "codespell" },
	languages = {
		sql = {
			lsps = {
				sqls = {},
			},
		},
		markdown = {
			formatters = { "prettier" },
			linters = { "markdownlint" },
		},
		python = {
			test_adapter = {
				author = "nvim-neotest",
				name = "neotest-python",
				config = {
					justMyCode = false,
				},
			},
			formatters = { "ruff_fix", "ruff_format" },
			dap_package = "debugpy",
			other = {
				debugpy_python_path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
			},
			linters = { "ruff" },
			lsps = {
				basedpyright = {
					settings = {

						basedpyright = {
							analysis = {
								autoSearchPaths = true,
								typeCheckingMode = "standard",
								useLibraryCodeForTypes = true,
							},
						},
					},
				},

				pylsp = {
					settings = {
						pylsp = {
							plugins = {
								pycodestyle = {
									ignore = {},
									maxLineLength = 120,
								},
							},
						},
					},
				},
			},
		},
		zig = {
			formatters = { "zig fmt" },
			lsps = {
				zls = {},
			},
		},
		rust = {
			test_adapter = {
				author = "rouge8",
				name = "neotest-rust",
			},
			formatters = { "rustfmt" },
		},
		bash = {
			linters = { "shellcheck" },
			lsps = {
				bashls = {},
			},
			formatters = { "shfmt", "shellharden" },
		},
		dockerfile = {
			linters = { "hadolint" },
		},
		json = {
			formatters = { "fixjson" },
			linters = { "jsonlint" },
			lsps = {
				jsonls = {
					-- INFO: Wrapping it as we can't guarantee that the plugin is installed at this point.
					settings = function()
						return {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						}
					end,
				},
			},
		},
		go = {
			test_adapter = {
				author = "nvim-neotest",
				name = "neotest-go",
			},
			formatters = { "gofmt", "goimports" },
			dap_package = "dlv",
			linters = { "golangcilint" },
			lsps = {
				gopls = {
					-- NOTE: go plugin take over here so should not pass on_attach.
					skip_on_attach = true,
					settings = {
						gopls = {
							gofumpt = true,
						},
					},
				},
			},
		},
		lua = {
			formatters = { "stylua" },
			lsps = {
				lua_ls = {
					settings = {
						Lua = {
							telemetry = {
								enabled = false,
							},
							workspace = {
								checkThirdParty = false,
							},
							diagnostics = {
								disable = { "missing-fields" },
							},
						},
					},
				},
			},
		},
		c_sharp = {
			test_adapter = {
				author = "Issafalcon",
				name = "neotest-dotnet",
			},
			formatters = { "csharpier" },
			dap_package = "netcoredbg",
			dap_configs = {
				{
					type = "netcoredbg",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						---@diagnostic disable-next-line
						return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
			},
			lsps = {
				omnisharp = {
					skip_capabilities = true,
				},
			},
		},
		yaml = {
			formatters = { "yamlfmt" },
			-- Tred yamllint but it stopped using it as its buggy.
			lsps = {
				yamlls = {
					-- INFO: Wrapping it as we can't guarantee that the plugin is installed at this point.
					settings = function()
						return {
							yaml = {
								schemaStore = {
									enable = false, -- using schemastore plugin instead (more functionalities)
									url = "", -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
								},
								schemas = require("schemastore").yaml.schemas({
									extra = require("atro.lsp.yaml_schemas"),
								}),
							},
						}
					end,
				},
			},
		},
		nix = {
			formatters = { "alejandra" }, -- Two other ones are nixfmt and nixpkgs-fmt, but alejendra seems the nicest to read.
			lsps = {
				-- INFO: Is worse than nixd but has very good go-to-definition.
				nil_ls = {},

				-- INFO: All around best nix lsp, except the go-to-definition is not working that well.
				nixd = {
					settings = {
						nixd = {
							diagnostic = {
								suppress = { "sema-escaping-with" },
							},
						},
					},
				},
			},
		},
		toml = {
			formatters = { "taplo" },
			lsps = {
				taplo = {},
			},
		},
	},
}
