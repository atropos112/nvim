---@class Logger
---@field kvs table<string, any>
local Logger = {}
Logger.__index = Logger

Logger.levels = {
	TRACE = 1,
	DEBUG = 2,
	INFO = 3,
	WARN = 4,
	ERROR = 5,
}

---@param levels string[]
function Logger:set_levels(levels)
	local logger_ok, logger = pcall(function()
		return require("structlog").get_logger("atro")
	end)
	if not logger_ok then
		Logger:init()
	end

	logger = require("structlog").get_logger("atro")
	if not logger then
		error("Logger not found")
	end

	for i, pipeline in ipairs(logger.pipelines) do
		pipeline.level = Logger.levels[levels[i]:upper()]
	end
end

---@param kvs table<string, any>
function Logger:with(kvs)
	local new_logger = vim.deepcopy(self)
	new_logger.kvs = vim.tbl_extend("force", self.kvs or {}, kvs or {})
	return new_logger
end

function Logger:init()
	local structlog_path = vim.fn.stdpath("data") .. "/lazy/structlog.nvim"
	if not vim.loop.fs_stat(structlog_path) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/Tastyep/structlog.nvim.git",
			"--branch=main", -- latest stable release
			structlog_path,
		})
	end
	if not vim.list_contains(vim.opt.rtp, structlog_path) then
		vim.opt.rtp:prepend(structlog_path)
	end
	if not self.kvs then
		self.kvs = {}
	end

	local structlog = require("structlog")
	local home_dir = os.getenv("HOME") -- Get the home directory
	local log_file_path = home_dir .. "/.local/share/nvim/atro.log" -- Construct the full path

	structlog.configure({
		atro = {
			pipelines = {
				{
					level = Logger.levels["ERROR"],
					processors = {
						structlog.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 3 }),
						structlog.processors.Timestamper("%H:%M:%S"),
					},

					formatter = structlog.formatters.FormatColorizer("%s [%-5s] %s: %-30s", { "timestamp", "level", "logger_name", "msg" }, { level = structlog.formatters.FormatColorizer.color_level() }),
					sink = structlog.sinks.Console(false), -- async=false
				},
				{
					level = Logger.levels["TRACE"],
					processors = {
						structlog.processors.StackWriter({ "line", "file" }, { max_parents = 3, stack_level = 3 }),
						structlog.processors.Timestamper("%F %H:%M:%S"),
					},
					formatter = structlog.formatters.Format("%s [%-5s]: %-30s", { "timestamp", "level", "msg", "logger_name" }),

					sink = structlog.sinks.File(log_file_path),
				},
			},
		},
	})

	self:info("----------------------------------------")

	return self
end

--- Adds a log entry using Plenary.log
---@param level integer [same as vim.log.levels]
---@param msg any
---@param kvs table<string, any>
function Logger:add_entry(level, msg, kvs)
	local logger = self:get_logger()
	if not logger then
		-- Can't guarantee that the logger is installed and initialized
		return
	end

	local all_kvs = self.kvs or {}
	all_kvs = vim.tbl_extend("force", all_kvs, kvs or {})

	logger:log(level, vim.inspect(msg), all_kvs)
end

---Retrieves the handle of the logger object
---@return table|nil logger handle if found
function Logger:get_logger()
	local logger_ok, logger = pcall(function()
		return require("structlog").get_logger("atro")
	end)

	if logger_ok and logger then
		return logger
	end

	logger = self:init()

	if not logger then
		return
	end

	self.__handle = logger
	return logger
end

---Add a log entry at TRACE level
---@param msg any
---@param kvs table<string, any> | nil
function Logger:trace(msg, kvs)
	local sent_kvs = self.kvs or {}
	if kvs then
		sent_kvs = vim.tbl_extend("force", sent_kvs, kvs)
	end

	self:add_entry(self.levels.TRACE, msg, sent_kvs)
end

---Add a log entry at DEBUG level
---@param msg any
---@param kvs table<string, any> | nil
function Logger:debug(msg, kvs)
	self:add_entry(self.levels.DEBUG, msg, kvs or {})
end

---Add a log entry at INFO level
---@param msg any
---@param kvs table<string, any> | nil
function Logger:info(msg, kvs)
	self:add_entry(self.levels.INFO, msg, kvs or {})
end

---Add a log entry at WARN level
---@param msg any
---@param kvs table<string, any> | nil
function Logger:warn(msg, kvs)
	self:add_entry(self.levels.WARN, msg, kvs or {})
end

---Add a log entry at ERROR level
---@param msg any
---@param kvs table<string, any> | nil
function Logger:error(msg, kvs)
	self:add_entry(self.levels.ERROR, msg, kvs or {})
	error(msg)
end

setmetatable({}, Logger)

return Logger
