local log = LOGGER:with({ phase = "Testing" })

local neotest_deps = function()
	if _G.neotest_deps then
		return _G.neotest_deps
	end

	local deps = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
	}
	for _, cfg in pairs(CONFIG.languages) do
		if cfg.test_adapter then
			table.insert(deps, cfg.test_adapter.pkg_name)
		end
	end
	log:debug("Constructing neotest dependencies: " .. require("atro.utils").lst_to_str(deps))

	_G.neotest_deps = deps
	return deps
end

---@type LazySpec[]
return {
	{
		"nvim-neotest/neotest",
		event = "VeryLazy",
		dependencies = neotest_deps(),
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			local nt = require("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			local adapters = {}
			for lang, cfg in pairs(CONFIG.languages) do
				if cfg.test_adapter then
					log:with({ language = lang }):debug("Including test adapter " .. cfg.test_adapter.adapter_name)
					if cfg.test_adapter.config then
						table.insert(adapters, require(cfg.test_adapter.adapter_name)(cfg.test_adapter.config))
					else
						table.insert(adapters, require(cfg.test_adapter.adapter_name))
					end
				end
			end

			-- INFO: This can't be set in opts because the dependencies are not loaded yet at that time.
			nt.setup({

				-- For all runners go to https://github.com/nvim-neotest/neotest#supported-runners
				-- adapters = require("atro.utils.config").RequireAllTestingAdapters(),
				adapters = adapters,
			})

			local keys = KEYMAPS.testing

			KEYMAPS:set_many({
				{ keys.attach, nt.run.attach },
				{
					keys.run_file,
					function()
						nt.run.run(vim.fn.expand("%"))
					end,
				},
				{
					keys.run_all_files,
					function()
						nt.run.run(vim.uv.cwd())
					end,
				},
				{
					keys.run_suite,
					function()
						nt.run.run({ suite = true })
					end,
				},
				{ keys.run_nearest, nt.run.run },
				{ keys.run_last, nt.run.run_last },
				{ keys.toggle_summary, nt.summary.toggle },
				{
					keys.open_output,
					function()
						nt.output.open({ enter = true, auto_close = true })
					end,
				},
				{ keys.toggle_output_panel, nt.output_panel.toggle },
				{ keys.stop, nt.run.stop },
				{
					keys.debug_nearest,
					function()
						nt.run.run({ strategy = "dap" })
					end,
				},
				{
					keys.debug_file,
					function()
						nt.run.run({ vim.fn.expand("%"), strategy = "dap" })
					end,
				},
			}, { noremap = false, silent = true })
		end,
	},
}
