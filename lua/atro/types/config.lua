---@enum AutoCompleteType
AutoCompleteType = {
	copilot = "copilot", -- Copilot auto-completion
	supermaven = "supermaven", -- SuperMaven auto-completion
}

---@class Config
---@field use_wakatime  boolean Should this nvim instance talk to external providers like Github Copilot
---@field global_linters string[] List of global linters for all languages
---@field languages table<string, LanguageConfig> List of language specific configurations
---@field logging Logging Log level for the logger
---@field null_ls_sources any[] | nil List of null-ls sources
---@field extra_git_linker_callbacks table<string, function> | function | nil List of git linker callbacks, if function it is evaluated at runtime and should return a table of string -> function
---@field extra_overseerr_tasks overseer.TemplateDefinition[] | nil List of extra overseer tasks
---@field mason_config MasonConfig | nil Mason configuration
---@field llm_config LLMConfig | nil LLM configuration
---@field auto_complete_type AutoCompleteType  | nil Type of LLM auto-completion to use e.g. "copilot" or "supermaven"

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

---@class LLMConfig
---@field kind string Type of the LLM adapter (ollama, openai, etc)
---@field adapter CodeCompanion.Adapter Adapter configuration
