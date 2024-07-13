local defaults = require("atro.configs.user_configs.defaults")
-- No assumption is made as to if there are overrides or not, the file might be missing.
local overrides = {}
if require("atro.utils.generic").file_exists(vim.fn.stdpath("config") .. "/lua/atro/configs/user_configs/overrides.lua") then
	overrides = require("atro.configs.user_configs.overrides")
end

-- Apply overrides
_G.user_conf = require("atro.utils.generic").merge_tables_at_root(defaults, overrides)
