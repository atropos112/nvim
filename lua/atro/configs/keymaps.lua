local set = require("atro.utils.generic").keyset

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

-- chmod +x current file
set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Save with Ctrl + s, in all modes
set("i", "<C-s>", "<cmd>w<CR>")
set("v", "<C-s>", "<cmd>w<CR>")
set("n", "<C-s>", "<cmd>w<CR>")

set("n", "<leader>of", function()
	vim.diagnostic.open_float()
end, { desc = "Diagnostic float" })

-- go back and forth when doing f/F select
set("n", "N", ";", { desc = "forward in f/F selcet" })
set("n", "P", ",", { desc = "backward in f/F select" })

-- move lines up and down by 5 lines up and down
set("n", "<C-j>", "5jzz")
set("n", "<C-k>", "5kzz")
