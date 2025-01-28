-- INFO: Took a lot of inspiration from https://github.com/chrisgrieser/nvim-kickstart-python/blob/main/kickstart-python.lua , thanks to the author.

if CONFIG.languages["python"] then
	--------------------------------------------------------------------------------
	-- SETUP BASIC PYTHON-RELATED OPTIONS

	-- The filetype-autocmd runs a function when opening a file with the filetype
	-- "python". This method allows you to make filetype-specific configurations. In
	-- there, you have to use `opt_local` instead of `opt` to limit the changes to
	-- just that buffer. (As an alternative to using an autocmd, you can also put those
	-- configurations into a file `/after/ftplugin/{filetype}.lua` in your
	-- nvim-directory.)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "python", -- filetype for which to run the autocmd
		callback = function()
			-- use pep8 standards
			vim.opt_local.expandtab = true
			vim.opt_local.shiftwidth = 4
			vim.opt_local.tabstop = 4
			vim.opt_local.softtabstop = 4

			-- folds based on indentation https://neovim.io/doc/user/fold.html#fold-indent
			-- if you are a heavy user of folds, consider using `nvim-ufo`
			vim.opt_local.foldmethod = "indent"

			-- Auto fixes my weird habits
			local iabbrev = function(lhs, rhs)
				vim.keymap.set("ia", lhs, rhs, { buffer = true })
			end
			-- automatically capitalize boolean values. Useful if you come from a
			-- different language, and lowercase them out of habit.
			iabbrev("true", "True")
			iabbrev("false", "False")

			-- we can also fix other habits we might have from other languages
			iabbrev("--", "#")
			iabbrev("null", "None")
			iabbrev("none", "None")
			iabbrev("nil", "None")
		end,
	})

	return {
		{
			"mfussenegger/nvim-dap-python",
			ft = "python",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
			config = function()
				local dappy = require("dap-python")
				local dap_path = CONFIG.languages["python"].other.debugpy_python_path

				if dap_path then
					dappy.setup(dap_path)
				else
					-- Trying to use the "python" we have in the path might not work if no debugpy there
					dappy.setup("python")
				end

				dappy.test_runner = "pytest"
			end,
		},
		-----------------------------------------------------------------------------
		-- PYTHON REPL
		-- A basic REPL that opens up as a horizontal split
		-- * use `<leader>i` to toggle the REPL
		-- * use `<leader>I` to restart the REPL
		-- * `+` serves as the "send to REPL" operator. That means we can use `++`
		-- to send the current line to the REPL, and `+j` to send the current and the
		-- following line to the REPL, like we would do with other vim operators.
		{
			"Vigemus/iron.nvim",
			keys = {
				{ "<leader>fi", vim.cmd.IronRepl, desc = "󱠤 Toggle REPL" },
				{ "<leader>fI", vim.cmd.IronRestart, desc = "󱠤 Restart REPL" },

				-- these keymaps need no right-hand-side, since that is defined by the
				-- plugin config further below
				-- { "+", mode = { "n", "x" }, desc = "󱠤 Send-to-REPL Operator" },
				-- { "++", desc = "󱠤 Send Line to REPL" },
			},

			-- since irons's setup call is `require("iron.core").setup`, instead of
			-- `require("iron").setup` like other plugins would do, we need to tell
			-- lazy.nvim which module to via the `main` key
			-- main = "iron.core",
			config = function()
				-- INFO: iron suggests using main = ... but then i can't do
				-- format = require("iron.fts.common").bracketed_paste and nothing works
				-- so i'm using the require("iron").core.setup instead
				require("iron").core.setup({
					ignore_blank_lines = false,
					scratch_repl = true,
					keymaps = {
						-- INFO: Definitely don't need them all.
						send_motion = "<space>sc",
						visual_send = "<space>sc",
						send_file = "<space>sf",
						send_line = "<space>sl",
						send_until_cursor = "<space>su",
						send_mark = "<space>sm",
						mark_motion = "<space>mc",
						mark_visual = "<space>mc",
						remove_mark = "<space>md",
						cr = "<space>s<cr>",
						interrupt = "<space>s<space>",
						exit = "<space>sq",
						clear = "<space>cl",
					},
					config = {
						-- This defines how the repl is opened. Here, we set the REPL window
						-- to open in a horizontal split to the bottom, with a height of 10.
						repl_open_cmd = "horizontal bot 10 split",

						-- This defines which binary to use for the REPL. If `ipython` is
						-- available, it will use `ipython`, otherwise it will use `python3`.
						-- since the python repl does not play well with indents, it's
						-- preferable to use `ipython` or `bypython` here.
						-- (see: https://github.com/Vigemus/iron.nvim/issues/348)
						repl_definition = {
							python = {
								format = require("iron.fts.common").bracketed_paste,
								command = function()
									local ipythonAvailable = vim.fn.executable("ipython") == 1
									local binary = ipythonAvailable and "ipython" or "python3"
									return { binary }
								end,
							},
						},
					},
				})
			end,
		},
	}
else
	return {}
end
