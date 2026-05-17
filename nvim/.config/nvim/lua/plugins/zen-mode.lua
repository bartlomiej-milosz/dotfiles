return {
    "folke/zen-mode.nvim",
    cmd          = "ZenMode",
    dependencies = { "folke/twilight.nvim" },
    keys         = {
        { "<leader>z", "<cmd>ZenMode<CR>", desc = "[Z]en mode toggle" },
    },
    opts         = {
        window = {
            backdrop = 0.95, -- subtle background dimming (1 = no effect)
            width    = 120,  -- fixed column width — consistent for code
            height   = 1,
            options  = {
                -- Keep these enabled — useful when coding
                -- signcolumn     = "no",
                -- number         = false,
                -- relativenumber = false,
                -- cursorline     = false,
            },
        },
        plugins = {
            options = {
                enabled    = true,
                showcmd    = false,
                laststatus = 0, -- hide statusline
            },
            -- twilight activates automatically when zen mode opens,
            -- dims all code outside the current function/block
            twilight = { enabled = true },
            gitsigns = { enabled = false }, -- hide git signs for clean view
        },
    },
}
