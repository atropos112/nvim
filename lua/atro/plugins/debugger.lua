return {

    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require("dap")
            local registry = require("mason-registry")
            local ensure_installed = {
                -- C#
                "netcoredbg",

                -- Python
                "debugpy",

                -- Rust
                "codelldb",
            }

            vim.keymap.set('n', '<leader>di', function() dap.step_into() end)
            vim.keymap.set('n', '<leader>c', function() dap.step_over() end)
            vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)


            registry.refresh(function()
                for _, pkg_name in ipairs(ensure_installed) do
                    local pkg = registry.get_package(pkg_name)
                    if not pkg:is_installed() then
                        pkg:install()
                    end
                end
            end)
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

            vim.keymap.set('n', '<leader>dc', function()
                dapui.open()
                dap.continue()
            end)
            vim.keymap.set('n', '<leader>dt', function()
                dap.terminate()
                dapui.close()
            end)

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
