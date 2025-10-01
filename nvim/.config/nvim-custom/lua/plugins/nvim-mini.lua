return {
    {
        "nvim-mini/mini.icons",
        version = false,
        opts = {
            -- Icon style options:
            -- 'glyph' - Beautiful Nerd Font icons (requires Nerd Font installed)
            --           Best visual experience, recommended if you have Nerd Fonts
            -- 'ascii' - Simple ASCII characters (*, +, -)
            --           Works everywhere, fallback if you see � or □ instead of icons
            style = "glyph",
            -- style = "ascii",  -- Uncomment if Nerd Fonts not available
        },
    },

    {
        'nvim-mini/mini.notify',
        version = false,
        -- lazy = false, -- force immediate load
        event = "VeryLazy",
        keys = {
            {
                "<leader>nh",
                function() require('mini.notify').show_history() end,
                desc = "Notification History"
            },
            {
                "<leader>nc",
                function() require('mini.notify').clear() end,
                desc = "Clear Notifications"
            },
        },
        opts = {
            content = {
                format = function(notif)
                    local ts = os.date('%H:%M:%S', notif.ts_update)
                    return string.format('[%s] %s', ts, notif.msg)
                end,
            },
            lsp_progress = {
                enable = true,
                duration_last = 1000,
            },
            window = {
                config = {
                    -- border = 'rounded',
                },
                max_width_share = 0.382,
                winblend = 25,
            },
        },
    },

    {
        "nvim-mini/mini.files",
        version = false
    },


    {
        "nvim-mini/mini.pick",
        opts = {},
        keys = {
            { "<leader>ff", "<cmd>Pick files<cr>",     desc = "Find files" },
            { "<leader>fb", "<cmd>Pick buffers<cr>",   desc = "Find buffers" }, -- ← BUFFERS!
            { "<leader>fg", "<cmd>Pick grep_live<cr>", desc = "Live grep" },
            { "<leader>fh", "<cmd>Pick help<cr>",      desc = "Help tags" },
            { "<leader>fr", "<cmd>Pick resume<cr>",    desc = "Resume" },
        },
    },

    {
        "nvim-mini/mini.clue",
        opts = function()
            local miniclue = require("mini.clue")
            return {
                triggers = {
                    { mode = "n", keys = "<leader>" },
                    { mode = "x", keys = "<leader>" },
                    { mode = "n", keys = "g" },
                    { mode = "n", keys = "[" },
                    { mode = "n", keys = "]" },
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "n", keys = '"' },
                },
                clues = {
                    -- Built-in clues
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),

                    -- Leader group descriptions
                    { mode = "n", keys = "<leader>c", desc = "+Code" },
                    { mode = "n", keys = "<leader>d", desc = "+Debug/Diagnostics" },
                    { mode = "n", keys = "<leader>f", desc = "+Find" },
                    { mode = "n", keys = "<leader>n", desc = "+Notifications" },
                    { mode = "n", keys = "<leader>r", desc = "+Rename" },
                    { mode = "n", keys = "<leader>t", desc = "+Test" },
                    { mode = "n", keys = "<leader>w", desc = "+Workspace" },

                    -- LSP Code Actions & Refactoring (from nvim-lspconfig.lua)
                    { mode = "n", keys = "<leader>ca", desc = "Code Action" },
                    { mode = "n", keys = "<leader>cf", desc = "Format File" },
                    { mode = "n", keys = "<leader>ch", desc = "Toggle Inlay Hints" },
                    { mode = "n", keys = "<leader>rn", desc = "Rename Symbol" },

                    -- LSP Diagnostics (from nvim-lspconfig.lua)
                    { mode = "n", keys = "<leader>dd", desc = "Show Diagnostic" },
                    { mode = "n", keys = "<leader>dq", desc = "Diagnostics to Quickfix" },
                    { mode = "n", keys = "<leader>dl", desc = "Diagnostics to Loclist" },
                    { mode = "n", keys = "[d", desc = "Previous Diagnostic" },
                    { mode = "n", keys = "]d", desc = "Next Diagnostic" },

                    -- LSP Navigation (from nvim-lspconfig.lua)
                    { mode = "n", keys = "gd", desc = "Go to Definition" },
                    { mode = "n", keys = "gD", desc = "Go to Declaration" },
                    { mode = "n", keys = "gi", desc = "Go to Implementation" },
                    { mode = "n", keys = "gr", desc = "Go to References" },
                    { mode = "n", keys = "gy", desc = "Go to Type Definition" },
                    { mode = "n", keys = "K",  desc = "Hover Documentation" },
                    { mode = "n", keys = "gK", desc = "Signature Help" },

                    -- LSP Workspace (from nvim-lspconfig.lua)
                    { mode = "n", keys = "<leader>wa", desc = "Add Workspace Folder" },
                    { mode = "n", keys = "<leader>wr", desc = "Remove Workspace Folder" },
                    { mode = "n", keys = "<leader>wl", desc = "List Workspace Folders" },

                    -- Mini.pick keymaps (from nvim-mini.lua)
                    { mode = "n", keys = "<leader>ff", desc = "Find Files" },
                    { mode = "n", keys = "<leader>fb", desc = "Find Buffers" },
                    { mode = "n", keys = "<leader>fg", desc = "Live Grep" },
                    { mode = "n", keys = "<leader>fh", desc = "Help Tags" },
                    { mode = "n", keys = "<leader>fr", desc = "Resume Search" },

                    -- Mini.notify keymaps (from nvim-mini.lua)
                    { mode = "n", keys = "<leader>nh", desc = "Notification History" },
                    { mode = "n", keys = "<leader>nc", desc = "Clear Notifications" },

                    -- Mason keymap (from mason.lua)
                    { mode = "n", keys = "<leader>cm", desc = "Open Mason" },

                    -- Java-specific keymaps (from ftplugin/java.lua)
                    { mode = "n", keys = "<leader>co", desc = "Organize Imports (Java)" },
                    { mode = "n", keys = "<leader>cv", desc = "Extract Variable (Java)" },
                    { mode = "n", keys = "<leader>cc", desc = "Extract Constant (Java)" },
                    { mode = "n", keys = "<leader>cm", desc = "Extract Method (Java)" },
                    { mode = "n", keys = "<leader>tc", desc = "Test Class (Java)" },
                    { mode = "n", keys = "<leader>tm", desc = "Test Method (Java)" },

                    -- DAP (Debug Adapter Protocol) keymaps (from nvim-dap.lua)
                    { mode = "n", keys = "<leader>db", desc = "Toggle Breakpoint" },
                    { mode = "n", keys = "<leader>dc", desc = "Continue" },
                    { mode = "n", keys = "<leader>di", desc = "Step Into" },
                    { mode = "n", keys = "<leader>do", desc = "Step Over" },
                    { mode = "n", keys = "<leader>dO", desc = "Step Out" },
                    { mode = "n", keys = "<leader>dr", desc = "Toggle REPL" },
                    { mode = "n", keys = "<leader>dl", desc = "Run Last" },
                    { mode = "n", keys = "<leader>dt", desc = "Terminate" },
                    { mode = "n", keys = "<leader>du", desc = "Toggle DAP UI" },
                },
                window = {
                    -- By default 1000ms
                    delay = 500,
                },
            }
        end,
    }
}
