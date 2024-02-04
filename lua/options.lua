-- For more options use :help clipboard etc. see available options

--  Other 
vim.o.clipboard = 'unnamedplus' -- make copy work with rest of OS
vim.o.number = true -- show numbers on the left
vim.o.relativenumber = true -- make those numbers relative
vim.o.signcolumn = 'yes'
vim.o.updatetime = 50
vim.o.termguicolors = true
vim.o.mouse = 'a'

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
