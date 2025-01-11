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
		keys = {
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run tests",
			},
			{
				"<leader>td",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Run tests with DAP",
			},
			{
				"<leader>ts",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop tests",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle watch",
			},
			{
				"<leader>tt",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle output panel",
			},
		},
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
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
					table.insert(adapters, require(cfg.test_adapter.adapter_name)(cfg.test_adapter.config or {}))
				end
			end

			-- INFO: This can't be set in opts because the dependencies are not loaded yet at that time.
			require("neotest").setup({

				-- For all runners go to https://github.com/nvim-neotest/neotest#supported-runners
				-- adapters = require("atro.utils.config").RequireAllTestingAdapters(),
				adapters = adapters,
			})
		end,
	},
}
