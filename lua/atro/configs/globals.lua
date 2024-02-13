-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Markdown Preview
vim.g.mkdp_auto_start = 1
vim.g.mkdp_auto_close = 1


-- LSP Config
-- LSP base settings, these will be used throughout the LSP setup
_G.On_attach = function(_, bufnr)
    -- a lot of repetition below, making a function and using that instead lowering the cluter a bit.
    local bufmap = function(keys, func)
        vim.keymap.set("n", keys, func, { buffer = bufnr })
    end

    bufmap("<leader>r", vim.lsp.buf.rename)
    bufmap("<leader>a", vim.lsp.buf.code_action)

    bufmap("gd", vim.lsp.buf.definition)
    bufmap("gD", vim.lsp.buf.declaration)
    bufmap("gI", vim.lsp.buf.implementation)
    bufmap("<leader>D", vim.lsp.buf.type_definition)

    bufmap("gr", require("telescope.builtin").lsp_references)

    bufmap("K", vim.lsp.buf.hover)

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, {})
end

_G.Capabilities = vim.lsp.protocol.make_client_capabilities()
