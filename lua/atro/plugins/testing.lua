return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-extensions/nvim-ginkgo",
            --"nvim-neotest/neotest-go",
            "nvim-neotest/neotest-python",
            "rouge8/neotest-rust",
            "Issafalcon/neotest-dotnet",
        },
        keys = {
            {"n", "<leader>tr", function() require('neotest').run.run() end, {desc = "Run test"}},
            {"n", "<leader>td", function() require('neotest').run.run({ strategy = "dap" }) end, {desc = "Debug test"}},
            {"n", "<leader>ts", function() require('neotest').run.stop() end, {desc = "Stop test"}},
            {"n", "<leader>tw", function() require('neotest').watch.toggle(vim.fn.expand("%")) end, {desc = "Watch test"}},
            {"n", "<leader>tt", function() require('neotest').summary.toggle() end, {desc = "Toggle test summary"}},
            {"n", "<leader>to", function() require('neotest').output_panel.toggle() end, {desc = "Toggle test output panel"}},
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    -- For all runners go to https://github.com/nvim-neotest/neotest#supported-runners
                    -- Python
                    require("neotest-python")({
                        dap = {
                            justMyCode = false,
                        },
                    }),
                    -- Go
                    --require("neotest-go"),
                    require("nvim-ginkgo"),
                    -- .NET
                    require("neotest-dotnet"),
                    -- Rust
                    require("neotest-rust"),
                },
            })
        end,
    },
}
