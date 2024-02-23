return {
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("atro.utils.mason").install("debugpy")
            local dappy = require('dap-python')
            dappy.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python") -- thats where Mason will drop it
            dappy.test_runner = "pytest"
        end,
    },
    {
        "roobert/f-string-toggle.nvim",
        ft = "python",
        opts = {
            key_binding = "<leader>f",
            key_binding_desc = "Toggle f-string"
        }
    }
}
