local M = {}

M.fmt_configs = {
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

return M
