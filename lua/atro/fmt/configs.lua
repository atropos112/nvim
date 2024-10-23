local M = {}

M.fmt_packages = function()
	local packages = {}
	local IsLangSupported = require("atro.utils.config").IsLangSupported
	local TableConcat = require("atro.utils.generic").TableConcat

	for lang, fmts in pairs(M.fmt_configs()) do
		if IsLangSupported(lang) then
			packages = TableConcat(packages, fmts)
		end
	end

	return packages
end

M.fmt_configs = function()
	if _G._fmt_configs then
		return _G._fmt_configs
	end

	-- INFO: For list of available formatters go to https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
	if require("atro.utils.generic").file_exists(vim.fn.stdpath("config") .. "/lua/atro/fmt/overrides.lua") then
		_G._fmt_configs = require("atro.fmt.overrides").fmt_configs()
	else
		_G._fmt_configs = {
			bash = { "shfmt", "shellharden" },
			rust = { "rustfmt" },
			lua = { "stylua" },
			zig = { "zig fmt" },
			python = { "ruff_fix", "ruff_format" },
			cs = { "csharpier" },
			go = { "gofmt", "goimports" },
			json = { "fixjson" },
			just = { "just" },
			nix = { "alejandra" }, -- Two other ones are nixfmt and nixpkgs-fmt, but alejendra seems the nicest to read.
			md = { "mdformat" },
			sh = { "shfmt", "shellharden" },
			yaml = { "yamlfmt" },
			toml = { "taplo" },
			markdown = { "prettier" },
		}
	end

	return _G._fmt_configs
end

return M
