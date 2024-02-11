local o = vim.opt

--  Other 
o.clipboard = 'unnamedplus' -- make copy work with rest of OS
o.number = true -- show numbers on the left
o.relativenumber = true -- make those numbers relative
o.signcolumn = 'yes'
o.updatetime = 50
o.termguicolors = true
o.mouse = 'a'

-- No backups,  and allow  undotree to have access  to days  of  code changes 
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir =  os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- number of spaces in our tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- incremental search and no highlight 
vim.opt.hlsearch = false
vim.opt.incsearch = true
