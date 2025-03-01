local set = vim.keymap.set

set("n", "<leader>pv", vim.cmd.Ex)

-- move selected line / block of text in visual mode
-- :m here is the move command set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

-- half page jumping and keeping in the same position on the screen
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")

-- paste foo over bar and then keep foo in registry rather than bar
set("x", "<leader>p", [["_dP]])

-- chmod +x current file
set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Save with Ctrl + s, in all modes
set({ "i", "v", "n" }, "<C-s>", "<cmd>w<CR>")

KEYMAPS:set(KEYMAPS.diagnostic.open_float, vim.diagnostic.open_float)

-- move lines up and down by 5 lines up and down
set({ "n", "v" }, "<C-j>", "7jzz")
set({ "n", "v" }, "<C-k>", "7kzz")

-- :tnoremap <Esc> <C-\><C-n>
-- Allowing escaping in terminal mode
set("t", "<Esc>", "<C-\\><C-n>")
