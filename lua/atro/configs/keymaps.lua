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

-- move lines up and down by 5 lines up and down
set({ "n", "v" }, "<C-j>", "7jzz")
set({ "n", "v" }, "<C-k>", "7kzz")

function ToLink()
	local origin = vim.fn.system("git remote -v | grep origin | head -n 1 | awk 'BEGIN{FS=\"/\"} {print $4\"/repos/\"$5}' | sed 's/\\.git (fetch)//'"):gsub("\n", "")
	local cmd = "echo " .. vim.fn.expand("%:p") .. " | sed 'sA'$(git rev-parse --show-toplevel)'AbrowseA'"
	local path = vim.fn.system(cmd):gsub("\n", "")
	local line_num_start, line_num_end
	if vim.fn.mode() == "V" then
		line_num_start = vim.fn.line("v")
		line_num_end = vim.fn.line(".")
		if line_num_start > line_num_end then
			line_num_start, line_num_end = line_num_end, line_num_start
		end
	else
		line_num_start = vim.api.nvim_win_get_cursor(0)[1]
		line_num_end = line_num_start
	end
	local res = "https://mangit.maninvestments.com/projects/" .. origin .. "/" .. path
	if line_num_start == line_num_end then
		res = res .. "#" .. line_num_start
	else
		res = res .. "#" .. line_num_start .. "-" .. line_num_end
	end
	res = res:gsub("\n", "")
	vim.fn.setreg("+", res)
end

set({ "n", "v" }, "<leader>cl", ToLink, { desc = "[C]opy [L]ink to current line(s)" })
