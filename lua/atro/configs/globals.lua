local g = vim.g

-- use space as leader key
g.mapleader = " "
g.maplocalleader = " "

-- disable netrw at the very start of your init.lua
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Markdown Preview
g.mkdp_auto_start = 0
g.mkdp_auto_close = 0

-- Go
g.go_fmt_command = "gopls"
g.go_gopls_gofumpt = 1

-- this is a bit of a hack to get the correct path to the sqlite3 shared object in nixos
local sqlite_so_path = os.getenv("ATRO_SQLITE3_SO_PATH")
if sqlite_so_path then
	g.sqlite_clib_path = sqlite_so_path
end

---@type rustaceanvim.Opts | fun():rustaceanvim.Opts | nil
g.rustaceanvim = function()
	local dap_cfgs = require("atro.dap.configs").dap_configs()
	local codelldb_path = dap_cfgs.rust.codelldb_path
	local liblldb_path = dap_cfgs.rust.liblldb_path

	local cfg = require("rustaceanvim.config")
	return {
		dap = {
			adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
		},
	}
end
