return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                progress = {
                    enabled = false,
                }
            }
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },
    {
        'rcarriga/nvim-notify',
        event = "VeryLazy",
        opts = {},
    },
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {},
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        main = "ibl",
        opts = {}
    }
}
