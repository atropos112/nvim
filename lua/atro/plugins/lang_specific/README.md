# Language support

A typical language support involves up to 6 parts

- Dependency sourcing
- Plugin specific
- LSP
- Linter
- Debugger
- Formatter (in a different file)

Where all of the code needs to be placed (which section) is outlined in _plugin specific_ section, what should be added is in each section separately.

## Dependency sourcing

Idea here is to request all binaries you need to do the next steps like formatter, lsp and linter. For clarity separate them as shown in example below
e.g.

```lua
require("atro.utils.mason").install({
    -- linter
    "jsonlint",

    -- lsp
    "json-lsp",
})
```

## Plugin specific

That is plugin dependent. If you have plugin place all of the above in that plugins `config` function so it gets loaded when plugin is loaded. If you don't have a plugin for a given language then do the below

```lua
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.lua",
    callback = function()
        CODE_HERE
    end
})

return {}
```

This will trigger the config when pattern is meet, its useful when a computer doesn't have all the needed dependencies (e.g. go).

## LSP

This part is somewhat repetetive, unless you have a plugin that deals with the LSP you must pass in `capabilities = Capabilities` and `on_attach = On_attach`.
The settings are quiet LSP dependent you can find docs [here](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) or call `:h lspconfig-all`.

```lua
require('lspconfig').jsonls.setup {
    capabilities = Capabilities,
    on_attach = On_attach,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = {
                enable = true
            },
        },
    },
}
```

## Linter

A single line

```lua
require("lint").linters_by_ft.markdown = { "write_good" }
```

Do note the name in the declare dependencies is the `Mason` name, while the one here is the linter name, to see what name you need, see [here](https://github.com/mfussenegger/nvim-lint#available-linters).

- Formatter

## Debugger

If you have a plugin, it's possible the plugin does this part for you and you don't need to do much (to test, open any code of that language and try to debug). You will need to parts

- adapter, i.e. what app needs to be ran to do the debugging
- configuration, i.e what

```lua
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
```

## Formatter

This one is awkward as it lives in the `../formatting.lua` file and you need to add a single line there, which will likely be something like

```lua
go = formatters.lsp,
```

in the `formatter_by_ft` section. Based on [this code](https://github.com/elentok/format-on-save.nvim/blob/main/lua/format-on-save/formatters/init.lua) I suspect the answer is almost always going to be `formatters.lsp`.
