-- use space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move selected line / block of text in visual mode
-- :m here is the move command
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- half page jumping and keeping in the same position on the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- paste foo over bar and then keep foo in registry rather than bar
vim.keymap.set("x", "<leader>p", [["_dP]])

-- replace all usages 
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- chmod +x current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
