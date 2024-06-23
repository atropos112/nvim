local M = {}

M.SelectedLSPs = function()
	local LSPs = {}
	for _, value in pairs(_G.user_conf.SupportedLanguages or {}) do
		if value.LSPs then
			for _, lsp in ipairs(value.LSPs) do
				table.insert(LSPs, lsp)
			end
		end
	end
	return LSPs
end

M.SupportedLanguages = function()
	local langs = {}
	for key, _ in pairs(_G.user_conf.SupportedLanguages or {}) do
		table.insert(langs, key)
	end
	return langs
end

M.IsLangSupported = function(lang)
	return _G.user_conf.SupportedLanguages[lang] ~= nil
end

function TestingAdapterFullNames()
	local adapters = {}
	for _, value in pairs(_G.user_conf.SupportedLanguages or {}) do
		if value.TestAdapter then
			table.insert(adapters, value.TestAdapter.author .. "/" .. value.TestAdapter.name)
		end
	end
	return adapters
end

function TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

M.WithTestingAdapterDeps = function(deps)
	return TableConcat(deps, TestingAdapterFullNames())
end

M.RequireAllTestingAdapters = function()
	local reqs = {}

	for _, lang_config in pairs(_G.user_conf.SupportedLanguages) do
		if lang_config.TestAdapter then
			table.insert(reqs, require(lang_config.TestAdapter.name)(lang_config.TestAdapter.config or {}))
		end
	end

	return reqs
end

return M
