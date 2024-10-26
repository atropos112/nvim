local M = {}

---@return nil
function M.init_default()
	---@type GlobalConfig
	GCONF = vim.deepcopy(require("atro.config.defaults"))

	require("atro.config.globals").load_defaults()
	require("atro.config.options").load_defaults()
	require("atro.config.autocmds").load_defaults()
	require("atro.config.keymaps").load_defaults()
end

---@param config_path string
---@return nil
function M.init_user(config_path)
	local _, _ = pcall(dofile, config_path)
end

return M
