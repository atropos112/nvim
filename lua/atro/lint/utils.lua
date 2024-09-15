local M = {}

---@return nil
M.install_linters = function()
	require("atro.utils.load").install_from_configs_table(require("atro.lint.configs").linter_configs())
end

return M
