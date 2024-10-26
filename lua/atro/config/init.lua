local M = {}

---@return nil
function M:init_default()
	LOGGER:info("Loading default configuration")

	---@type GlobalConfig
	GCONF = vim.deepcopy(require("atro.config.defaults"))
	require("atro.utils.logs"):set_levels({ GCONF.logging.consol_log_level, GCONF.logging.file_log_level })
	LOGGER:trace(GCONF)

	require("atro.config.globals").load_defaults()
	require("atro.config.options").load_defaults()
	require("atro.config.autocmds").load_defaults()
	require("atro.config.keymaps").load_defaults()
end

---@param config_path string
---@return nil
function M:init_user(config_path)
	LOGGER:info("Loading user configuration")
	local _, _ = pcall(dofile, config_path)
	require("atro.utils.logs"):set_levels({ GCONF.logging.consol_log_level, GCONF.logging.file_log_level })
	LOGGER:trace(GCONF)
end

return M
