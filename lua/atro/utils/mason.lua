local M = {}

M.install = function(ensure_installed)
    -- Allow for passing in a single string
    if (type(ensure_installed) == "string") then
        ensure_installed = { ensure_installed }
    end

    local registry = require('mason-registry')
    registry.refresh(function()
        for _, pkg_name in ipairs(ensure_installed) do
            local pkg = registry.get_package(pkg_name)
            if not pkg:is_installed() then
                pkg:install()
            end
        end
    end)
end

return M
