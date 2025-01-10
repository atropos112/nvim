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

---@class MasonConfig
---@field pip_install_args string[] | nil Arguments to pass to pip install
