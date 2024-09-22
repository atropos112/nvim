local M = {}

---@return nil
M.install_daps = function()
	require("atro.utils.load").install_from_configs_table(require("atro.dap.configs").dap_configs())
end

return M
