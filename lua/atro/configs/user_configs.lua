local defaults = require("atro.configs.defaults")
-- No assumption is made as to if there are overrides or not, the file might be missing.
local overrides
local status, overrides_res = pcall(require, "override_globals")
if status then
	overrides = overrides_res
else
	overrides = {}
end

-- Function to replace defaults with overrides
local function apply_overrides(user_defaults, user_overrides)
	local result = {}
	for k, v in pairs(user_defaults) do
		result[k] = v
	end
	for k, v in pairs(user_overrides) do
		result[k] = v
	end
	return result
end

-- Apply overrides
_G.user_conf = apply_overrides(defaults, overrides)
