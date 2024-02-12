return {
    -- Undo tree i.e. a fancy "go back"  history
    {
        "mbbill/undotree",
        config = function()
            vim.g.undotree_WindowLayout = 2
            vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)
        end,
    },
    {
        '0x00-ketsu/autosave.nvim',
        config = function()
            require('autosave').setup {
                events = {
                    "InsertLeave",
                    "FocusLost"
                }
            }
        end
    }
}
