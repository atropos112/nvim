---@class LanguageConfig
---@field treesitters string[] | nil List of treesitters for this language
---@field linters string[] | nil List of linters for this language
---@field formatters nil | table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride> List of formatters for this language
---@field lsps table<string,LspConfig> | nil List of lsps for this language
---@field test_adapter TestAdapter | nil Test adapter configuration for this language
---@field dap_package string | nil Dap package for this language
---@field dap_adapters table<string, dap.Adapter> | nil Dap adapters for this language
---@field dap_configs dap.Configuration[] | nil Dap configuration for this language
---@field other table<string, any> | nil Other configuration options

---@class LspConfig
---@field settings table<string, any> | function | nil Lsp settings
---@field skip_on_attach boolean | nil Skip adding the on_attach function to the client
---@field on_attach function | nil On attach function to add to the client on top of the default
---@field skip_capabilities boolean | nil Skip adding the capabilities to the client
---@field skip_install boolean | nil Skip installing the lsp even if it is not installed
---@field on_new_config function | nil Mutation of config after the root dir has been detected

---@class TestAdapter
---@field pkg_name string Name of the package to install as a dependency of neotest
---@field adapter_name string Name of the adapter to use, its what is added to require("neotest").adapters
---@field config table<string, any> | nil Configuration for the test adapter

---@enum LogLevel
LogLevel = {
	TRACE = "TRACE",
	DEBUG = "DEBUG",
	INFO = "INFO",
	WARN = "WARN",
	ERROR = "ERROR",
}

return {
	---@type any[] | nil List of null-ls sources
	null_ls_sources = nil,

	mason_config = {
		---@type string[] | nil Arguments to pass to pip install
		pip_install_args = {},
	},

	---@type overseer.TemplateDefinition[] | nil List of extra overseer tasks
	extra_overseerr_tasks = {},

	---@type table<string, function> | function | nil List of git linker callbacks, if function it is evaluated at runtime and should return a table of string -> function
	extra_git_linker_callbacks = {},

	logging = {
		---@type LogLevel Log level for the console
		consol_log_level = LogLevel.ERROR,

		---@type LogLevel Log level for the file
		file_log_level = LogLevel.DEBUG,
	},

	---@type boolean Should github copilot integration be enabled
	copilot_enabled = true,

	---@type boolean Should wakatime integration be enabled
	wakatime_enabled = true,

	llm_config = {
		---@type string Type of the LLM adapter (ollama, openai, etc)
		kind = "ollama",

		---@type table Adapter configuration
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

	---@type string[] List of global linters for all languages
	global_linters = { "codespell" },

	---@type table<string, LanguageConfig> List of language specific configurations
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
				ruff_format = {},
			},
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
			formatters = {
				biome = {
					-- https://biomejs.dev/formatter/
					args = { "format", "--indent-style", "space", "--stdin-file-path", "$FILENAME" },
				},
			},
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
			test_adapter = {
				pkg_name = "fredrikaverpil/neotest-golang",
				adapter_name = "neotest-golang",
				config = {
					go_test_args = {
						"-race",
						"-tags",
						"assert",
						"-parallel=10",
					},
					runner = "gotestsum",
				},
			},
			formatters = { ["golangci-lint"] = {} },
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
				yamlfmt = {
					prepend_args = function(_, _)
						return {
							"-formatter",
							-- WARN: If you change this you will have to adjust yamlint behaviour somehow as well,
							-- its quiet messy, ideally leave it as is.
							-- https://github.com/google/yamlfmt/blob/main/docs/config-file.md#configuration-1
							"can_folded_as_literal=true,include_document_start=true,drop_merge_tag=true,pad_line_comments=2",
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
