---@meta

---@param name string
---@return string
local name_to_binary = function(name)
	local exceptions = {
		["lua_ls"] = "lua-language-server",
		["jsonls"] = "vscode-json-language-server",
		["yamlls"] = "yaml-language-server",
		["ruff_fix"] = "ruff",
		["ruff_format"] = "ruff",
		["golangcilint"] = "golangci-lint",
	}

	return exceptions[name] or name
end

---@param name string
---@return string
local name_to_mason_name = function(name)
	local exceptions = {
		["als"] = "ada-language-server",
		["angularls"] = "angular-language-server",
		["ansiblels"] = "ansible-language-server",
		["antlersls"] = "antlers-language-server",
		["apex_ls"] = "apex-language-server",
		["arduino_language_server"] = "arduino-language-server",
		["asm_lsp"] = "asm-lsp",
		["ast_grep"] = "ast-grep",
		["astro"] = "astro-language-server",
		["autotools_ls"] = "autotools-language-server",
		["awk_ls"] = "awk-language-server",
		["azure_pipelines_ls"] = "azure-pipelines-language-server",
		["bashls"] = "bash-language-server",
		["beancount"] = "beancount-language-server",
		["bicep"] = "bicep-lsp",
		["bright_script"] = "brighterscript",
		["bsl_ls"] = "bsl-language-server",
		["bufls"] = "buf-language-server",
		["cairo_ls"] = "cairo-language-server",
		["clarity_lsp"] = "clarity-lsp",
		["clojure_lsp"] = "clojure-lsp",
		["cmake"] = "cmake-language-server",
		["cobol_ls"] = "cobol-language-support",
		["codeqlls"] = "codeql",
		["coq_lsp"] = "coq-lsp",
		["csharp_ls"] = "csharp-language-server",
		["css_variables"] = "css-variables-language-server",
		["cssls"] = "css-lsp",
		["cssmodules_ls"] = "cssmodules-language-server",
		["cucumber_language_server"] = "cucumber-language-server",
		["custom_elements_ls"] = "custom-elements-languageserver",
		["cypher_ls"] = "cypher-language-server",
		["dagger"] = "cuelsp",
		["denols"] = "deno",
		["dhall_lsp_server"] = "dhall-lsp",
		["diagnosticls"] = "diagnostic-languageserver",
		["docker_compose_language_service"] = "docker-compose-language-service",
		["dockerls"] = "dockerfile-language-server",
		["dotls"] = "dot-language-server",
		["drools_lsp"] = "drools-lsp",
		["elixirls"] = "elixir-ls",
		["elmls"] = "elm-language-server",
		["ember"] = "ember-language-server",
		["emmet_language_server"] = "emmet-language-server",
		["emmet_ls"] = "emmet-ls",
		["erg_language_server"] = "erg-language-server",
		["erlangls"] = "erlang-ls",
		["eslint"] = "eslint-lsp",
		["facility_language_server"] = "facility-language-server",
		["fennel_language_server"] = "fennel-language-server",
		["fennel_ls"] = "fennel-ls",
		["flux_lsp"] = "flux-lsp",
		["foam_ls"] = "foam-language-server",
		["gitlab_ci_ls"] = "gitlab-ci-ls",
		["golangci_lint_ls"] = "golangci-lint-langserver",
		["golangcilint"] = "golangci-lint",
		["gradle_ls"] = "gradle-language-server",
		["grammarly"] = "grammarly-languageserver",
		["graphql"] = "graphql-language-service-cli",
		["groovyls"] = "groovy-language-server",
		["harper_ls"] = "harper-ls",
		["haxe_language_server"] = "haxe-language-server",
		["hdl_checker"] = "hdl-checker",
		["helm_ls"] = "helm-ls",
		["hls"] = "haskell-language-server",
		["hoon_ls"] = "hoon-language-server",
		["html"] = "html-lsp",
		["htmx"] = "htmx-lsp",
		["hydra_lsp"] = "hydra-lsp",
		["java_language_server"] = "java-language-server",
		["jedi_language_server"] = "jedi-language-server",
		["jinja_lsp"] = "jinja-lsp",
		["jqls"] = "jq-lsp",
		["jsonls"] = "json-lsp",
		["jsonnet_ls"] = "jsonnet-language-server",
		["julials"] = "julia-lsp",
		["kotlin_language_server"] = "kotlin-language-server",
		["lelwel_ls"] = "lelwel",
		["ltex"] = "ltex-ls",
		["lua_ls"] = "lua-language-server",
		["luau_lsp"] = "luau-lsp",
		["lwc_ls"] = "lwc-language-server",
		["matlab_ls"] = "matlab-language-server",
		["mdx_analyzer"] = "mdx-analyzer",
		["mm0_ls"] = "metamath-zero-lsp",
		["motoko_lsp"] = "motoko-lsp",
		["move_analyzer"] = "move-analyzer",
		["mutt_ls"] = "mutt-language-server",
		["neocmake"] = "neocmakelsp",
		["nginx_language_server"] = "nginx-language-server",
		["nickel_ls"] = "nickel-lang-lsp",
		["nil_ls"] = "nil",
		["nim_langserver"] = "nimlangserver",
		["nimls"] = "nimlsp",
		["ocamllsp"] = "ocaml-lsp",
		["opencl_ls"] = "opencl-language-server",
		["openscad_lsp"] = "openscad-lsp",
		["pest_ls"] = "pest-language-server",
		["pico8_ls"] = "pico8-ls",
		["pkgbuild_language_server"] = "pkgbuild-language-server",
		["powershell_es"] = "powershell-editor-services",
		["prismals"] = "prisma-language-server",
		["prosemd_lsp"] = "prosemd-lsp",
		["puppet"] = "puppet-editor-services",
		["purescriptls"] = "purescript-language-server",
		["pylsp"] = "python-lsp-server",
		["quick_lint_js"] = "quick-lint-js",
		["r_language_server"] = "r-languageserver",
		["raku_navigator"] = "raku-navigator",
		["reason_ls"] = "reason-language-server",
		["remark_ls"] = "remark-language-server",
		["rescriptls"] = "rescript-language-server",
		["rnix"] = "rnix-lsp",
		["robotframework_ls"] = "robotframework-lsp",
		["ruby_lsp"] = "ruby-lsp",
		["ruff_lsp"] = "ruff-lsp",
		["ruff_fix"] = "ruff",
		["ruff_format"] = "ruff",
		["rust_analyzer"] = "rust-analyzer",
		["salt_ls"] = "salt-lsp",
		["shopify_theme_ls"] = "shopify-cli",
		["slint_lsp"] = "slint-lsp",
		["smithy_ls"] = "smithy-language-server",
		["snakeskin_ls"] = "snakeskin-cli",
		["solc"] = "solidity",
		["solidity"] = "solidity-ls",
		["solidity_ls"] = "vscode-solidity-server",
		["solidity_ls_nomicfoundation"] = "nomicfoundation-solidity-language-server",
		["somesass_ls"] = "some-sass-language-server",
		["spectral"] = "spectral-language-server",
		["starlark_rust"] = "starlark-rust",
		["stimulus_ls"] = "stimulus-language-server",
		["stylelint_lsp"] = "stylelint-lsp",
		["svelte"] = "svelte-language-server",
		["swift_mesonls"] = "swift-mesonlsp",
		["tailwindcss"] = "tailwindcss-language-server",
		["teal_ls"] = "teal-language-server",
		["terraformls"] = "terraform-ls",
		["theme_check"] = "shopify-theme-check",
		["ts_ls"] = "typescript-language-server",
		["tsp_server"] = "tsp-server",
		["twiggy_language_server"] = "twiggy-language-server",
		["typos_lsp"] = "typos-lsp",
		["typst_lsp"] = "typst-lsp",
		["unocss"] = "unocss-language-server",
		["v_analyzer"] = "v-analyzer",
		["vala_ls"] = "vala-language-server",
		["vale_ls"] = "vale-ls",
		["veryl_ls"] = "veryl-ls",
		["vhdl_ls"] = "rust_hdl",
		["vimls"] = "vim-language-server",
		["visualforce_ls"] = "visualforce-language-server",
		["volar"] = "vue-language-server",
		["vuels"] = "vetur-vls",
		["wgsl_analyzer"] = "wgsl-analyzer",
		["yamlls"] = "yaml-language-server",
	}

	return exceptions[name] or name
end

---@param name string
---@return boolean
local name_to_skip_install = function(name)
	local exceptions = {
		"zig fmt",
		"nlua",
	}

	return vim.list_contains(exceptions, name)
end

---@class AtroPackage
---@field name string The name used by non-mason tools
---@field bin_name string The name of the corresponding binary that will appear in the path when installed
---@field mason_name string The name of the package in the mason registry
local AtroPackage = {}
AtroPackage.__index = AtroPackage

-- Constructor
---@param name string
---@return AtroPackage
function AtroPackage:new(name)
	self.name = name
	self.bin_name = name_to_binary(name)
	self.mason_name = name_to_mason_name(name)
	self.skip_install = name_to_skip_install(name)

	return self
end

---@return boolean
function AtroPackage:bin_exists()
	return vim.fn.executable(self.bin_name) == 1
end

---@param registry any The registry that comes from the mason package
function AtroPackage:install(registry)
	if self.skip_install then
		return
	end

	if not self:bin_exists() then
		local pkg = registry.get_package(self.mason_name)
		if not pkg:is_installed() then
			pkg:install()
		end
	end
end

return AtroPackage
