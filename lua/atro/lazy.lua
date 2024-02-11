-- If there  is no lazy-vim package manager, download it and add it to the runtimepath
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

-- Add lazy-vim to the runtimepath
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{
			import = "atro.plugins",
		},
		{
			import = "atro.plugins.lang_specific",
		},
	}
})

