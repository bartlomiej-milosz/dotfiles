return {
    content = {
        filter = function(entry)
            local hidden_files = {
                [".DS_Store"] = true,
                [".classpath"] = true,
                [".project"] = true,
                [".settings"] = true,
                ["__pycache__"] = true,
                [".pytest_cache"] = true,
                [".mypy_cache"] = true,
                [".ipynb_checkpoints"] = true
            }
            return not hidden_files[entry.name]
        end,
    },
    mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "L",
        go_out = "h",
        go_out_plus = "H",
        mark_goto = "'",
        mark_set = "m",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
    },
    vim.keymap.set("n", "<leader>e", ":lua MiniFiles.open()<CR>", { desc = "Toggle [E]xplorer" }),
}
