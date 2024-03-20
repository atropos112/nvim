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

-- Work proxy
g.copilot_proxy = "euro-webproxy.drama.man.com:8080"
g.copilot_proxy_strict_ssl = false
vim.cmd([[ autocmd BufNewFile,BufRead *.mb2 set filetype groovy]])
