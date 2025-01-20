local M = {}

---@return nil
function M:init_default()
	LOGGER:info("Loading default configuration")
	require("atro.types")

	require("atro.utils.logs"):set_levels({ CONFIG.logging.consol_log_level, CONFIG.logging.file_log_level })
	LOGGER:trace(CONFIG)
	LOGGER:trace(KEYMAPS)

	require("atro.config.globals").load_defaults()
	require("atro.config.options").load_defaults()
	require("atro.config.autocmds").load_defaults()
	require("atro.config.generic_keymaps")
	-- require("atro.config.default_keymaps").load_defaults()

end

---@param config_path string
---@return nil
function M:init_user(config_path)
	LOGGER:info("Loading user configuration " .. config_path)
	if require("atro.utils").file_exists(config_path) == false then
		LOGGER:info("User configuration file does not exist, skipping.")
		return
	end

	-- Get all .lua files in the dir
	local files = require("atro.utils").get_files(config_path, ".lua")

	for _, file in ipairs(files) do
		LOGGER:debug("Loading user configuration file: " .. file)
		local ok, err = pcall(dofile, config_path .. "/" .. file)
		if not ok then
			LOGGER:error("Found file for user configuration but couldn't load it: " .. err)
		end
	end

	require("atro.utils.logs"):set_levels({ CONFIG.logging.consol_log_level, CONFIG.logging.file_log_level })
	LOGGER:trace(CONFIG)

	-- INFO: This is a good place to check if GCONF has been modified during execution. Same for keymaps.
	local GCONF_initial = vim.deepcopy(CONFIG)
	local KEYMAPS_initial = vim.deepcopy(KEYMAPS)
	local validate_gconf_didnt_change = function()
		LOGGER:info("Checking if GCONF or KEYMAPS have been modified during execution")

		if not KEYMAPS or not KEYMAPS_initial then
			LOGGER:error("KEYMAPS or KEYMAPS_initial is nil.")
		end

		if not CONFIG or not GCONF_initial then
			LOGGER:error("GCONF or GCONF_initial is nil.")
		end

		if not vim.deep_equal(KEYMAPS, KEYMAPS_initial) then
			LOGGER:error("KEYMAPS has been modified during execution.")
		else
			LOGGER:debug("KEYMAPS remains unchanged during execution, as expected.")
		end

		if not vim.deep_equal(CONFIG, GCONF_initial) then
			LOGGER:error("GCONF has been modified during execution.")
		else
			LOGGER:debug("GCONF remains unchanged during execution, as expected.")
		end
	end

	vim.defer_fn(validate_gconf_didnt_change, 1000) -- 1 second delay to allow for all plugins to load
	vim.defer_fn(validate_gconf_didnt_change, 4000) -- 4 second delay to allow for all plugins to load, for super slow machines
end

return M
