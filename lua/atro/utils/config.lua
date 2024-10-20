local M = {}

---@param key string
---@return string[]
M.UserSelected = function(key)
	local keys = {}
	for _, value in pairs(_G.user_conf.SupportedLanguages or {}) do
		if value[key] then
			for _, item in ipairs(value[key]) do
				table.insert(keys, item)
			end
		end
	end
	return keys
end

---@return string[]
M.UserSelectedLSPs = function()
	return M.UserSelected("LSPs")
end

---@return string[]
M.SupportedLanguages = function()
	local langs = {}
	for key, _ in pairs(_G.user_conf.SupportedLanguages or {}) do
		table.insert(langs, key)
	end
	return langs
end

---@param lang string
---@return boolean
M.IsLangSupported = function(lang)
	return _G.user_conf.SupportedLanguages[lang] ~= nil
end

---@return string[]
function TestingAdapterFullNames()
	local adapters = {}
	for _, value in pairs(_G.user_conf.SupportedLanguages or {}) do
		if value.TestAdapter then
			table.insert(adapters, value.TestAdapter.author .. "/" .. value.TestAdapter.name)
		end
	end
	return adapters
end

---@param deps table<string>
---@return table<string>
M.WithTestingAdapterDeps = function(deps)
	return require("atro.utils.generic").TableConcat(deps, TestingAdapterFullNames())
end

---@return table<unknown>
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
