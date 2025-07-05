require("atro.types.config")
---@type Config
return {
	logging = {
		consol_log_level = "error",
		file_log_level = "debug",
	},
	auto_complete_type = AutoCompleteType.copilot,
	llm_config = {
		kind = "ollama",
		adapter = {
			schema = {
				model = {
					default = "qwen2.5-coder:14b",
				},
				num_ctx = {
					default = 16384,
				},
				num_predict = {
					default = -1,
				},
			},
			env = {
				url = "http://ollama:11434",
			},
			parameters = {
				sync = true,
			},
		},
	},
	log_level = "DEBUG",
	use_wakatime = true,
	global_linters = { "codespell" },
	languages = {
		csv = {},
		sql = {
			lsps = {
				sqls = {},
			},
			linters = { "sqlfluff" },
			formatters = { sqlfluff = {} },
		},
		ocaml = {
			lsps = {
				ocamllsp = {},
			},
			formatters = {
				ocamlformat = {},
			},
			dap_package = "ocamlearlybird",
		},
		markdown = {
			treesitters = { "markdown", "markdown_inline" },
			formatters = {
				markdownlint = {},
				prettierd = {}, -- Is prettier with daemon mode for speed.
			},
			linters = { "markdownlint" },
			lsps = {
				marksman = {},
				-- TOOD: It leaks into other files like .lua
				-- harper_ls = {
				-- 	settings = {
				-- 		["harper-ls"] = {
				-- 			-- INFO: This is where global dictionary is stored.
				-- 			userDictPath = "~/.local/share/nvim/harper_dict.txt",
				-- 			-- INFO: The file specific dictionary is stored in
				-- 			-- ~/.local/share/harper-ls/file_dictionaries
				-- 		},
				-- 	},
				-- },
			},
		},
		python = {
			test_adapter = {
				pkg_name = "nvim-neotest/neotest-python",
				adapter_name = "neotest-python",
				config = {
					justMyCode = false,
				},
			},
			formatters = {
				ruff_fix = {},
				ruff_organize_imports = {},
				ruff_format = {

					args = function(_, _)
						return {
							"format",
							"--force-exclude",
							"--line-length",
							"120",
							"--stdin-filename",
							"$FILENAME",
							"-",
						}
					end,
				},
			},
			dap_package = "debugpy",
			other = {
				-- The debugpy_python_path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
			},
			linters = { "ruff" },
			lsps = {
				ruff = {
					on_attach = function(client, _)
						-- Basedpyright has better code actions than pylsp. And pylsp somehow blocks basedpyright
						client.server_capabilities.codeActionProvider = false
						client.server_capabilities.hoverProvider = false -- Making sure basedpyright hover is used as this one sucks.
					end,
				},
				basedpyright = {
					on_attach = function(client, _)
						-- Basedpyright does not support these capabilities well.
						client.server_capabilities.definitionProvider = false
						client.server_capabilities.typeDefinitionProvider = false
						client.server_capabilities.implementationProvider = false
						client.server_capabilities.referencesProvider = false
					end,
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
				pylsp = {
					on_attach = function(client, _)
						-- Basedpyright has better code actions than pylsp. And pylsp somehow blocks basedpyright
						client.server_capabilities.codeActionProvider = false
						client.server_capabilities.hoverProvider = false -- Making sure basedpyright hover is used as this one sucks.
					end,
					settings = {
						pylsp = {
							plugins = {
								pycodestyle = {
									enabled = false,
									ignore = {},
									maxLineLength = 180,
								},
								autopep8 = {
									enabled = false,
								},
								flake8 = {
									enabled = false,
								},
								mccabe = {
									enabled = false,
								},
								pyflakes = {
									enabled = false,
								},
								pylint = {
									enabled = false,
								},
								rope_autoimport = {
									enabled = false,
								},
								yapf = {
									enabled = false,
								},
							},
						},
					},
				},
			},
		},
		jsonnet = {
			lsps = {
				jsonnet_ls = {},
			},
			formatters = { jsonnetfmt = {} },
		},
		zig = {
			formatters = { zigfmt = {} },
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
			formatters = { rustfmt = {} },
			-- INFO: rustaceanvim plugin takes care of this
			-- lsps = {
			-- 	rust_analyzer = {},
			-- },
		},
		sh = { -- Has to be sh (not bash) for dap config match.
			treesitters = { "bash" },
			linters = { "shellcheck" },
			lsps = {
				bashls = {},
			},
			formatters = { shfmt = {}, shellharden = {} },
			dap_package = "bash-debug-adapter",
			dap_adapters = {
				bashdb = {
					type = "executable",
					command = "bash-debug-adapter",
				},
			},
			dap_configs = {
				{
					type = "bashdb",
					request = "launch",
					name = "Bash: Launch file",
					program = "${file}",
					cwd = "${fileDirname}",
					pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
					pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
					pathBash = "bash",
					pathCat = "cat",
					pathMkfifo = "mkfifo",
					pathPkill = "pkill",
					env = {},
					args = {},
				},
			},
		},
		docker = {
			treesitters = { "dockerfile" },
			linters = { "hadolint" },
			lsps = {
				dockerls = {},
				-- docker_compose_language_service would require setting filetype to yaml.docker-compose which
				-- is a bit annoying to do and it doesn't seem to bring much.
			},
		},
		json = {
			treesitters = { "json", "json5" },
			formatters = { fixjson = {} },
			linters = { "jsonlint" },
			lsps = {
				jsonls = {
					-- INFO: Wrapping it as we can't guarantee that the plugin is installed at this point.
					settings = function()
						return {
							json = {
								schemas = require("schemastore").json.schemas(),
								format = {
									enable = true,
								},
								validate = { enable = true },
							},
						}
					end,
				},
			},
		},
		go = {
			treesitters = { "go", "gomod", "gowork", "gosum" },
			-- INFO: The plugin olexsmir/gopher.nvim provides another test adapter for ginkgo
			-- So here we only need to provide the adapter for go test.
			test_adapter = {
				pkg_name = "nvim-neotest/neotest-go",
				adapter_name = "neotest-go",
			},
			formatters = { gofumpt = {}, goimports = {} },
			dap_package = "dlv",
			linters = { "golangcilint" },
			lsps = {
				gopls = {
					settings = {
						gopls = {
							analyses = {
								ST1003 = true,
								fieldalignment = false,
								fillreturns = true,
								nilness = true,
								nonewvars = true,
								shadow = true,
								undeclaredname = true,
								unreachable = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							codelenses = {
								gc_details = true, -- Show a code lens toggling the display of gc's choices.
								generate = true, -- show the `go generate` lens.
								regenerate_cgo = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							buildFlags = { "-race", "-tags", "integration" },
							completeUnimported = true,
							diagnosticsDelay = "100ms",
							gofumpt = true,
							matcher = "Fuzzy",
							semanticTokens = true,
							staticcheck = false, -- Using thorugh golangci-lint
							symbolMatcher = "fuzzy",
							usePlaceholders = false, -- This is super annoying.
						},
					},
				},
			},
		},
		templ = {
			lsps = {
				templ = {},
			},
		},
		lua = {
			formatters = {
				stylua = {},
			},
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
			formatters = { csharpier = {} },
			dap_package = "netcoredbg",
			lsps = {
				omnisharp = {
					skip_capabilities = true,
				},
			},
		},
		yaml = {
			treesitters = { "yaml", "helm" },
			formatters = {
				yamlfix = {},
				yamlfmt = {
					prepend_args = function(_, _)
						return {
							"-formatter",
							-- WARN: This is a custom configuration for yamlfmt. Main concern was it mushing multiline strings into one line. It doesn't do that AS long as there is at MOST one comment line in the multi string. A compromise for sure.
							"scan_folded_as_literal=true,retain_line_breaks=true,include_document_start=true,drop_merge_tag=true",
						}
					end,
				},
			},
			-- Tried yaml lint but it stopped using it as its buggy.
			lsps = {
				yamlls = {
					-- INFO: Wrapping it as we can't guarantee that the plugin is installed at this point.
					settings = function()
						return {
							redhat = { telemetry = { enabled = false } },
							yaml = {
								schemas = require("schemastore").yaml.schemas({ extra = require("atro.lsp.yaml_schemas") }),
								keyOrdering = false,
								format = {
									enable = true,
								},
								validate = true,
								schemaStore = {
									-- Must disable built-in schemaStore support to use
									-- schemas from SchemaStore.nvim plugin
									enable = false,
									-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
									url = "",
								},
							},
						}
					end,
				},
			},
		},
		proto = {
			lsps = {
				buf_ls = {},
			},
			formatters = { buf = {} },
		},
		nix = {
			formatters = { alejandra = {} }, -- Two other ones are nixfmt and nixpkgs-fmt, but alejendra seems the nicest to read.
			lsps = {
				-- INFO: Is worse than nixd but has very good go-to-definition.
				nil_ls = {},

				-- INFO: All around best nix lsp, except the go-to-definition is not working that well.
				nixd = {
					on_attach = function(client, _)
						-- To get capabilities of a given lsp:
						-- LspStop to stop all then start the one you want and then run
						-- :lua =vim.lsp.get_active_clients()[1].server_capabilities
						--
						-- Disabling in favour of nix_ls's better go-to-definition.
						client.server_capabilities.definitionProvider = false
						client.server_capabilities.typeDefinitionProvider = false
						client.server_capabilities.implementationProvider = false
						client.server_capabilities.referencesProvider = false
					end,

					settings = {
						nixd = {
							nixpkgs = {
								expr = "import <nixpkgs> { }",
							},
							formatting = {
								command = { "nixfmt" },
							},
							diagnostic = {
								suppress = { "sema-escaping-with" },
							},

							options = {
								-- my own nixos config
								nixos = {
									expr = '(builtins.getFlake "/home/atropos/nixos").nixosConfigurations.giant.options',
								},
							},
						},
					},
				},
			},
		},
		toml = {
			formatters = { taplo = {} },
			lsps = {
				taplo = {},
			},
		},
	},
}
