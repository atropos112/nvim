local M = {}

---@return nil
M.install_fmts = function()
	require("atro.utils.load").install_from_configs_table(require("atro.fmt.configs").fmt_configs())
end

return M
