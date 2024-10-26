local Log = {}

Log.levels = {
	TRACE = 1,
	DEBUG = 2,
	INFO = 3,
	WARN = 4,
	ERROR = 5,
}

---@param levels string[]
function Log:set_levels(levels)
	local logger_ok, logger = pcall(function()
		return require("structlog").get_logger("atro")
	end)
	if not logger_ok then
		Log:init()
	end

	logger = require("structlog").get_logger("atro")
	if not logger then
		error("Logger not found")
	end

	for i, pipeline in ipairs(logger.pipelines) do
		pipeline.level = Log.levels[levels[i]:upper()]
	end
end

function Log:init()
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
	vim.opt.rtp:prepend(structlog_path)

	local structlog = require("structlog")

	structlog.configure({
		atro = {
			pipelines = {
				{
					level = Log.levels["ERROR"],
					processors = {
						structlog.processors.StackWriter({ "line", "file" }, { max_parents = 0, stack_level = 3 }),
						structlog.processors.Timestamper("%H:%M:%S"),
					},
					formatter = structlog.formatters.FormatColorizer("%s [%-5s] %s: %-30s", { "timestamp", "level", "logger_name", "msg" }, { level = structlog.formatters.FormatColorizer.color_level() }),
					sink = structlog.sinks.Console(false), -- async=false
				},
				{
					level = Log.levels["TRACE"],
					processors = {
						structlog.processors.StackWriter({ "line", "file" }, { max_parents = 3, stack_level = 3 }),
						structlog.processors.Timestamper("%F %H:%M:%S"),
					},
					formatter = structlog.formatters.Format("%s [%-5s] %s: %-30s", { "timestamp", "level", "logger_name", "msg" }),
					sink = structlog.sinks.File(vim.fn.stdpath("config") .. "/atro.log"),
				},
			},
		},
	})

	LOGGER = self

	return structlog.get_logger("atro")
end

--- Adds a log entry using Plenary.log
---@param level integer [same as vim.log.levels]
---@param msg any
---@param event any
function Log:add_entry(level, msg, event)
	local logger = self:get_logger()
	if not logger then
		-- Can't guarantee that the logger is installed and initialized
		return
	end
	logger:log(level, vim.inspect(msg), event)
end

---Retrieves the handle of the logger object
---@return table|nil logger handle if found
function Log:get_logger()
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
---@param event any
function Log:trace(msg, event)
	self:add_entry(self.levels.TRACE, msg, event)
end

---Add a log entry at DEBUG level
---@param msg any
---@param event any
function Log:debug(msg, event)
	self:add_entry(self.levels.DEBUG, msg, event)
end

---Add a log entry at INFO level
---@param msg any
---@param event any
function Log:info(msg, event)
	self:add_entry(self.levels.INFO, msg, event)
end

---Add a log entry at WARN level
---@param msg any
---@param event any
function Log:warn(msg, event)
	self:add_entry(self.levels.WARN, msg, event)
end

---Add a log entry at ERROR level
---@param msg any
---@param event any
function Log:error(msg, event)
	self:add_entry(self.levels.ERROR, msg, event)
end

setmetatable({}, Log)

return Log
