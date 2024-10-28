---@meta
pcall(require, "dap")

---@class GlobalConfig
---@field talk_to_external boolean Should this nvim instance talk to external providers like Github Copilot
---@field global_linters string[] List of global linters for all languages
---@field languages table<string, LanguageConfig> List of language specific configurations
---@field logging Logging Log level for the logger
---@field null_ls_sources any[] | nil List of null-ls sources
---@field git_linker_callbacks table<string, function> | function | nil List of git linker callbacks, if function it is evaluated at runtime and should return a table of string -> function
---@field mason_config table<string, any> | nil Mason configuration

---@class LanguageConfig
---@field linters string[] | nil List of linters for this language
---@field formatters string[] | nil List of formatters for this language
---@field lsps table<string,LspConfig> | nil List of lsps for this language
---@field test_adapter TestAdapter | nil Test adapter configuration for this language
---@field dap_package string | nil Dap package for this language
---@field dap_adapters table<string, dap.Adapter|Dap.AdapterFactory> | nil Dap adapters for this language
---@field dap_configs dap.Configuration[] | nil Dap configuration for this language
---@field other table<string, any> | nil Other configuration options

---@class LspConfig
---@field settings table<string, any> | function | nil Lsp settings
---@field skip_on_attach boolean | nil Skip adding the on_attach function to the client
---@field skip_capabilities boolean | nil Skip adding the capabilities to the client
---@field skip_install boolean | nil Skip installing the lsp even if it is not installed

---@class TestAdapter
---@field name string Name of the test adapter
---@field author string Author of the test adapter
---@field config table<string, any> | nil Configuration for the test adapter

---@enum LogLevel
LogLevel = {
	TRACE = "TRACE",
	DEBUG = "DEBUG",
	INFO = "INFO",
	WARN = "WARN",
	ERROR = "ERROR",
}

---@class Logging
---@field consol_log_level LogLevel Log level for the console
---@field file_log_level LogLevel Log level for the file
