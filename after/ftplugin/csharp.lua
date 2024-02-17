-- NOTE: Dependency sourcing
require("atro.utils.mason").install({
    -- lsp
    "csharp-language-server",

    -- debugger
    "netcoredbg",
})

-- NOTE: LSP
local csharp_ext = require('csharpls_extended')
require("lspconfig").csharp_ls.setup({
    capabilities = Capabilities,
    handlers = {
        ["textDocument/definition"] = csharp_ext.handler,
        ["textDocument/typeDefinition"] = csharp_ext.handler,
    },
    cmd = { "csharp-ls" },
})

-- NOTE: Debugger
local dap = require('dap')
dap.adapters.netcoredbg = {
    type = 'executable',
    command = 'netcoredbg',
    args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
    {
        type = "netcoredbg",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            ---@diagnostic disable-next-line
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
}
