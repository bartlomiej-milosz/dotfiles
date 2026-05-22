return {
    -- ── Rose Pine: minimal, modern, paper-like light + soho-style dark ──
    {
        "rose-pine/neovim",
        name     = "rose-pine",
        lazy     = false,
        priority = 1000,
        config   = function()
            require("rose-pine").setup({
                variant      = "auto", -- follow vim.opt.background ("dark" -> dark_variant, "light" -> dawn)
                dark_variant = "main", -- "main" (default) | "moon" (softer dark)
                styles       = {
                    bold        = true,
                    italic      = true,
                    transparency = false,
                },
                highlight_groups = {
                    -- Subtle line numbers; keep cursor line number readable.
                    LineNr       = { fg = "muted" },
                    CursorLineNr = { fg = "text", bold = true },
                },
            })
        end,
    },

    -- ── Auto dark/light mode based on macOS system preference ──
    {
        "f-person/auto-dark-mode.nvim",
        lazy     = false,
        priority = 999,
        opts     = {
            update_interval = 1000,

            set_dark_mode = function()
                vim.opt.background = "dark"
                vim.cmd.colorscheme("rose-pine")
            end,

            set_light_mode = function()
                vim.opt.background = "light"
                vim.cmd.colorscheme("rose-pine")
            end,
        },
    },
}
