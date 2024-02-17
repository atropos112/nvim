local g = vim.g

-- use space as leader key
g.mapleader = ' '
g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Markdown Preview
g.mkdp_auto_start = 1
g.mkdp_auto_close = 1

_G.Capabilities = vim.lsp.protocol.make_client_capabilities()
Capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
