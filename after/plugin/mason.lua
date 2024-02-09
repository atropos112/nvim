-- Selecting bunch of dependencies for LSP, Debugger, decleratively.
local registry = require("mason-registry")
local packages = {
	-- Markdown
	"write-good", -- Linter

	-- Yaml
	"actionlint", -- Linter
	"yamllint", -- Linter

	-- Lua
	"lua-language-server", -- LSP
	"luacheck", -- Linter

	-- Json
	"jsonlint", -- Linter

	-- Shell
	"shellcheck", -- Linter

	-- SQL
	"sqlfluff", -- Linter

	-- C++
	"cpplint", -- Linter

	-- Rust
	"rust-analyzer", -- LSP
	"codelldb", -- Debugger

	-- C#
	"omnisharp", -- LSP
	"netcoredbg", -- Debugger

	-- Nix
	"nil", -- LSP
	"rnix-lsp", -- LSP

	-- Go
	"gopls", -- LSP
	"revive", -- Linter

	-- Python
	"black", -- Formatter
	"isort", -- Formatter
	"debugpy", -- Debugger
	"python-lsp-server", -- LSP
	"flake8", -- Linter
	"mypy", -- Linter
	"vulture", -- Linter
	"pylint", -- Linter
	"pyright", -- Linter
	"ruff", -- Linter

	-- Dockerfile
	"hadolint", -- Linter

	-- All
	"typos", -- Linter
}

registry.refresh(function()
	for _, pkg_name in ipairs(packages) do
		local pkg = registry.get_package(pkg_name)
		if not pkg:is_installed() then
			pkg:install()
		end
	end
end)
