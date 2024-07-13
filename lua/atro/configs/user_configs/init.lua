local defaults = require("atro.configs.user_configs.defaults")
-- No assumption is made as to if there are overrides or not, the file might be missing.
local overrides
local status, overrides_res = pcall(require, "atro.configs.user_configs.overrides")
if status then
	overrides = overrides_res
else
	overrides = {}
end

-- Apply overrides
_G.user_conf = require("atro.utils.generic").merge_tables_at_root(defaults, overrides)
