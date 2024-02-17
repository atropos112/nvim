local set = vim.keymap.set -- alias

set("n", "<leader>pv", vim.cmd.Ex)

-- move selected line / block of text in visual mode
-- :m here is the move command
set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

-- half page jumping and keeping in the same position on the screen
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")

-- paste foo over bar and then keep foo in registry rather than bar
set("x", "<leader>p", [["_dP]])

-- replace all usages
set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- chmod +x current file
set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Save with Ctrl + s, in all modes
set("i", "<C-s>", "<cmd>w<CR>")
set("v", "<C-s>", "<cmd>w<CR>")
set("n", "<C-s>", "<cmd>w<CR>")
