local M = {}

M.keyset = function(mode, key, cmd, opts)
	opts = opts or {}
	vim.keymap.set(mode, key, cmd, opts)
end

return M
