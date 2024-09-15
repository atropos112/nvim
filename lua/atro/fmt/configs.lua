local M = {}

M.fmt_configs = function()
	if _G._fmt_configs then
		return _G._fmt_configs
	end

	-- Lazy eval
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
			nix = { "alejandra" },
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
