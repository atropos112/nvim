return {
    -- API info of vim
    {
        "folke/neodev.nvim",
        ft = "lua",
        config = function()
            require("neodev").setup()
        end,
    },
}
