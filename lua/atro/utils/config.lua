local M = {}
-- Function to check if a language is supported
--
M.lang_supported = function(lang)
	for _, v in ipairs(_G.user_conf.supported_languages) do
		if v == lang then
			return true
		end
	end
	return false
end

return M
