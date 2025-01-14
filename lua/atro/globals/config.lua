---@type Config
return {
	logging = {
		consol_log_level = "ERROR",
		file_log_level = "DEBUG",
	},
	log_level = "DEBUG",
	talk_to_external = true,
	global_linters = { "codespell" },
	global_lsps = {
		-- INFO: Not sure how to use the dict yet.
		harper_ls = {
			settings = {
				["harper-ls"] = {
					codeActions = {
						forceStable = true,
					},
					userDictPath = vim.fn.stdpath("config") .. "/dict/user_dict.txt",
					linters = {
						spell_check = true,
						spelled_numbers = false,
						an_a = true,
						sentence_capitalization = false, -- otherwise makes ~/.local -> ~/.Local suggestions.
						unclosed_quotes = true,
						wrong_quotes = false,
						long_sentences = true,
						repeated_words = true,
						spaces = true,
						matcher = true,
						correct_number_suffix = true,
						number_suffix_capitalization = true,
						multiple_sequential_pronouns = true,
						linking_verbs = false,
						avoid_curses = true,
						terminating_conjunctions = true,
					},
				},
			},
		},
	},
	languages = {
		csv = {},
		sql = {
			lsps = {
				sqls = {},
			},
			linters = { "sqlfluff" },
		},
		markdown = {
			formatters = { "prettier" },
			linters = { "markdownlint" },
		},
		python = {
			test_adapter = {
				pkg_name = "nvim-neotest/neotest-python",
				adapter_name = "neotest-python",
				config = {
					justMyCode = false,
				},
			},
			formatters = { "ruff_fix", "ruff_format" },
			dap_package = "debugpy",
			other = {
				-- The debugpy_python_path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
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
								autoImportCompletions = true,
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
			dap_package = "codelldb",
			test_adapter = {
				-- rustaceanvim is already loaded separately but it is a dependency
				-- of neotesting so adding it here as a pkg_name.
				pkg_name = "mrkjkb/rustaceanvim",
				adapter_name = "rustaceanvim.neotest",
			},
			formatters = { "rustfmt" },
			-- INFO: rustaceanvim plugin takes care of this
			-- lsps = {
			-- 	rust_analyzer = {},
			-- },
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
			-- INFO: The plugin olexsmir/gopher.nvim provides another test adapter for ginkgo
			-- So here we only need to provide the adapter for go test.
			test_adapter = {
				pkg_name = "nvim-neotest/neotest-go",
				adapter_name = "neotest-go",
			},
			formatters = { "gofmt", "goimports" },
			dap_package = "dlv",
			linters = { "golangcilint" },
			lsps = {
				gopls = {
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
								global = {
									"LOGGER",
									"GCONF",
									"vim",
								},
								disable = { "missing-fields" },
							},
						},
					},
				},
			},
		},
		c_sharp = {
			test_adapter = {
				pkg_name = "Issafalcon/neotest-dotnet",
				adapter_name = "neotest-dotnet",
			},
			formatters = { "csharpier" },
			dap_package = "netcoredbg",
			lsps = {
				omnisharp = {
					skip_capabilities = true,
				},
			},
		},
		yaml = {
			formatters = { "yamlfmt" },
			-- Tried yaml lint but it stopped using it as its buggy.
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
				-- TODO: Re-enable this when nix_ls is fixed with pipe operators like here https://github.com/oxalica/nil/pull/152
				-- nil_ls = {},

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
