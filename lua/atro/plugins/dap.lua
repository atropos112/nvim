local set = vim.keymap.set
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

            set('n', '<leader>di', dap.step_into, { desc = "Step into" })
            set('n', '<leader>c', dap.step_over, { desc = "Step over" })
            -- INFO: You can do breakpoint with dap.toggle_breakpoint but it's not persistent and hence the persistent-breakpoints plugin usage instead.
        end,
    },
    {
        'Weissle/persistent-breakpoints.nvim',
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            local pb = require('persistent-breakpoints')
            pb.setup {
                load_breakpoints_event = { "BufReadPost" }
            }
            -- WARN: I realise this looks super ugly and it appears like you can simply have require('persistent-breakpoints.api').toggle_breakpoint instead but it doesn't work.
            set("n", "<leader>bb", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>",
                { desc = "Toggle breakpoint", remap = true })
            set("n", "<leader>bc", "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>",
                { desc = "Set conditional breakpoint" })
            set("n", "<leader>ba", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>",
                { desc = "Clear all breakpoints" })
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
