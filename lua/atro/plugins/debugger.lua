return {
    {
        "theHamsta/nvim-dap-virtual-text",
        event = "VeryLazy",
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'mfussenegger/nvim-dap'
        },
        opts = {}
    },
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require("dap")

            vim.keymap.set('n', '<leader>di', function() dap.step_into() end, { desc = "Step into" })
            vim.keymap.set('n', '<leader>c', function() dap.step_over() end, { desc = "Step over" })
            vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        event = "VeryLazy",
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()

            vim.keymap.set('n', '<leader>ds', function()
                dapui.open()
                dap.continue()
            end, { desc = "Start debugging" })
            vim.keymap.set('n', '<leader>dt', function()
                dap.terminate()
                dapui.close()
            end, { desc = "Stop debugging" })

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end

            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end

            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
}
