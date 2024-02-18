return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({})
            vim.api.nvim_set_keymap("n", "<leader>nt", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
        end,
    },
    -- LOOK INTO THIS.
    -- {
    --     "stevearc/oil.nvim",
    --     opts = {}
    -- }
}
