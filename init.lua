require("atro.configs")
require("atro.lazy")

-- look for extra config at ~/.config/extra_nvim.lua
-- This is for device specific configs that should live outside (for whatever reason)
-- The use of this is discouraged, unless there is no other way.
if require("atro.utils.generic").dir_exists("~/.config/extra_nvim") then
	vim.o.runtimepath = vim.o.runtimepath .. "," .. vim.fn.expand("~/.config/extra_nvim")
	require("atro.utils.load").load_all_lua_files("~/.config/extra_nvim")
end
