require("atro.config.types")
pcall(require, "dap")

---@type GlobalConfig
return {
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

			lsps = {
				hadolint = {},
			},
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
				nixd = {
					skip_install = true,
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
