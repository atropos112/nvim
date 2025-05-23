local M = {}
local o = vim.opt

function M.load_defaults()
	o.expandtab = true
	o.shiftwidth = 4
	o.tabstop = 4
	o.softtabstop = 4

	--  Other
	o.clipboard = "unnamedplus" -- make copy work with rest of OS
	o.number = true -- show numbers on the left
	o.relativenumber = false -- make those numbers relative or not
	o.signcolumn = "yes"
	o.updatetime = 50
	o.termguicolors = true
	o.mouse = "a"

	-- No backups,  and allow  undotree to have access  to days  of  code changes
	o.swapfile = false
	o.backup = false
	o.undodir = { os.getenv("HOME") .. "/.vim/undodir" }
	o.undofile = true

	-- number of spaces in our tabs
	o.tabstop = 4
	o.shiftwidth = 4

	-- incremental search and no highlight
	o.hlsearch = false
	o.incsearch = true

	-- folding
	o.foldcolumn = "0" -- '0' is not bad
	o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
	o.foldlevelstart = 99
	o.foldenable = true

	-- screen jumping
	o.laststatus = 3
	o.splitkeep = "screen"
end

return M
