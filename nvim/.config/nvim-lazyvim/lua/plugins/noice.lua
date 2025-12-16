return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    opts = {
        cmdline = {
            enabled = true,
            view = "cmdline_popup", -- fancy centered popup
        },
        messages = {
            enabled = true, -- let mini.notify handle messages
        },
        popupmenu = {
            enabled = false, -- let blink.cmp handle this
        },
        notify = {
            enabled = true, -- let mini.notify handle notifications
        },
        lsp = {
            progress = {
                enabled = true, -- let mini.notify handle LSP progress
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
        },
    },
}
