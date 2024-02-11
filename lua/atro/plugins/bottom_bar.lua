return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            'f-person/git-blame.nvim'
        },
        event = "VeryLazy",
        init = function()
            require("lualine").setup({
                icons_enabled = true,
                theme = "catppuccin",
            })
        end,
    }
}
