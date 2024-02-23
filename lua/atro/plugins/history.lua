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
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup {
                log_level = "error",

                auto_session_suppress_dirs = { "~/", "~/Downloads" },

                cwd_change_handling = {
                    restore_upcoming_session = true,
                    pre_cwd_changed_hook = nil,
                    post_cwd_changed_hook = function()
                        require("lualine").refresh()
                    end,
                },
            }
        end
    }
}
