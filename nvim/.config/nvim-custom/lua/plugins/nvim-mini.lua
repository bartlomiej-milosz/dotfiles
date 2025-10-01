return {
    {
        "nvim-mini/mini.icons",
        version = false,
        opts = {
            style = "glyph",
        },
    },

    {
        "nvim-mini/mini.notify",
        version = false,
        event = "VeryLazy",
        keys = {
            {
                "<leader>nh",
                function() require("mini.notify").show_history() end,
                desc = "Notification History"
            },
            {
                "<leader>nc",
                function() require("mini.notify").clear() end,
                desc = "Clear Notifications"
            },
        },
        opts = {
            content = {
                format = function(notif)
                    local ts = os.date("%H:%M:%S", notif.ts_update)
                    return string.format("[%s] %s", ts, notif.msg)
                end,
            },
            lsp_progress = {
                enable = true,
                duration_last = 1000,
            },
        },
        config = function(_, opts)
            require("mini.notify").setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "mininotify-history",
                callback = function(event)
                    vim.keymap.set("n", "q", "<cmd>bdelete<cr>", { buffer = event.buf })
                end,
            })
        end,
    },

    {
        "nvim-mini/mini.files",
        opts = {
            windows = {
                preview = true,
                width_preview = 50,
            },
        },
        keys = {
            {
                "<leader>e",
                function()
                    if not require("mini.files").close() then
                        require("mini.files").open()
                    end
                end,
                desc = "Explorer Toggle",
            },
            {
                "<leader>E",
                "<cmd>lua require('mini.files').open(vim.api.nvim_buf_get_name(0))<cr>",
                desc = "Explorer (Current File)",
            },
        },
    },

    {
        "nvim-mini/mini.pick",
        version = false,
        opts = {},
        keys = {
            { "<leader>ff", "<cmd>Pick files<cr>",     desc = "Find files" },
            { "<leader>fb", "<cmd>Pick buffers<cr>",   desc = "Find buffers" },
            { "<leader>fg", "<cmd>Pick grep_live<cr>", desc = "Live grep" },
            { "<leader>fh", "<cmd>Pick help<cr>",      desc = "Help tags" },
            { "<leader>fr", "<cmd>Pick resume<cr>",    desc = "Resume" },
        },
    },

    {
        "nvim-mini/mini.clue",
        version = false,
        config = function()
            local miniclue = require("mini.clue")
            miniclue.setup({
                triggers = {
                    -- Leader triggers
                    { mode = "n", keys = "<Leader>" },
                    { mode = "x", keys = "<Leader>" },
                    -- Built-in completion
                    { mode = "i", keys = "<C-x>" },
                    -- `g` key
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },
                    -- Marks
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "'" },
                    { mode = "x", keys = "`" },
                    -- Registers
                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },
                    -- Window commands
                    { mode = "n", keys = "<C-w>" },
                    -- `z` key
                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },
                    -- Text objects
                    { mode = "o", keys = "a" },
                    { mode = "o", keys = "i" },
                    { mode = "x", keys = "a" },
                    { mode = "x", keys = "i" },
                },

                clues = {
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),

                    -- Leader group descriptions
                    { mode = "n", keys = "<leader>c",  desc = "+Code" },
                    { mode = "n", keys = "<leader>e",  desc = "+Explorer" },
                    { mode = "n", keys = "<leader>f",  desc = "+Find" },
                    { mode = "n", keys = "<leader>n",  desc = "+Notifications" },

                    -- Mini.files keymaps
                    { mode = "n", keys = "<leader>e",  desc = "Toggle Explorer" },
                    { mode = "n", keys = "<leader>E",  desc = "Explorer (Current File)" },

                    -- Mini.pick keymaps
                    { mode = "n", keys = "<leader>ff", desc = "Find Files" },
                    { mode = "n", keys = "<leader>fb", desc = "Find Buffers" },
                    { mode = "n", keys = "<leader>fg", desc = "Live Grep" },
                    { mode = "n", keys = "<leader>fh", desc = "Help Tags" },
                    { mode = "n", keys = "<leader>fr", desc = "Resume Search" },

                    -- Mini.notify keymaps
                    { mode = "n", keys = "<leader>nh", desc = "Notification History" },
                    { mode = "n", keys = "<leader>nc", desc = "Clear Notifications" },

                    -- Mini.ai keymaps
                    { mode = "o", keys = "af",         desc = "around function" },
                    { mode = "o", keys = "if",         desc = "inner function" },
                    { mode = "o", keys = "ac",         desc = "around class" },
                    { mode = "o", keys = "ic",         desc = "inner class" },
                    { mode = "o", keys = "ao",         desc = "around code block" },
                    { mode = "o", keys = "io",         desc = "inner code block" },
                    { mode = "o", keys = "ad",         desc = "around digits" },
                    { mode = "o", keys = "id",         desc = "inner digits" },
                    { mode = "o", keys = "au",         desc = "around function call" },
                    { mode = "o", keys = "iu",         desc = "inner function call" },
                    { mode = "o", keys = "aU",         desc = "around function call (no dots)" },
                    { mode = "o", keys = "iU",         desc = "inner function call (no dots)" },

                    -- Mini.ai keymaps
                    { mode = "x", keys = "af",         desc = "around function" },
                    { mode = "x", keys = "if",         desc = "inner function" },
                    { mode = "x", keys = "ac",         desc = "around class" },
                    { mode = "x", keys = "ic",         desc = "inner class" },
                    { mode = "x", keys = "ao",         desc = "around code block" },
                    { mode = "x", keys = "io",         desc = "inner code block" },
                    { mode = "x", keys = "ad",         desc = "around digits" },
                    { mode = "x", keys = "id",         desc = "inner digits" },
                    { mode = "x", keys = "au",         desc = "around function call" },
                    { mode = "x", keys = "iu",         desc = "inner function call" },
                    { mode = "x", keys = "aU",         desc = "around function call (no dots)" },
                    { mode = "x", keys = "iU",         desc = "inner function call (no dots)" },
                },

                window = {
                    config = {},
                    delay = 1000,
                    scroll_down = "<C-d>",
                    scroll_up = "<C-u>",
                },
            })
        end,
    }
}
