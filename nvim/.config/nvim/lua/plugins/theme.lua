return {
    -- ── zenbones: contrast-based, low-color colorscheme collection ──
    {
        "zenbones-theme/zenbones.nvim",
        dependencies = "rktjmp/lush.nvim",
        lazy         = false,
        priority     = 1000,
        config       = function()
            -- zenwritten: zero hue/saturation variant — ideal for long sessions
            -- Configuration is set via vim.g before applying the colorscheme

            -- Dark variant: default lightness
            --   'stark' = higher contrast  |  'warm' = warmer, lower contrast
            --   omit for balanced default (recommended)
            vim.g.zenwritten = {
                darken_comments                    = 38, -- slightly muted comments
                darken_non_text                    = 38,
                solid_line_nr                      = false, -- subtle line numbers
                solid_float_border                 = true, -- visible borders on floating windows
                colorize_diagnostic_underline_text = true,
            }

            -- Light variant: same config, 'dim' lightness feels more paper-like
            -- Lightness is set dynamically by auto-dark-mode below
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
                vim.cmd.colorscheme("zenwritten")
            end,

            set_light_mode = function()
                vim.opt.background = "light"
                -- 'dim' lightness: softer, paper-like — easier on eyes in bright light
                vim.g.zenwritten_lightness = "dim"
                vim.cmd.colorscheme("zenwritten")
            end,
        },
    },
}
