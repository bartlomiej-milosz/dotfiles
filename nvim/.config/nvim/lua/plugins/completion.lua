-- blink.cmp: modern, fast completion engine with native snippet support.
-- Capabilities are advertised to LSPs in lsp.lua via get_lsp_capabilities().
return {
    {
        "saghen/blink.cmp",
        version      = "*", -- prefer release versions (ship pre-built fuzzy matcher)
        event        = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "rafamadriz/friendly-snippets" }, -- a curated snippet pack across languages
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "default",                 -- C-Space open, C-n/p select, C-y accept, C-e cancel
                ["<CR>"]    = { "accept",  "fallback" },
                ["<Tab>"]   = { "snippet_forward",  "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
            },

            appearance = { nerd_font_variant = "mono" },

            completion = {
                accept       = { auto_brackets = { enabled = true } },
                documentation = { auto_show = true, auto_show_delay_ms = 200 },
                ghost_text    = { enabled = true },
                list          = { selection = { preselect = false, auto_insert = true } },
                menu          = {
                    border       = "rounded",
                    draw         = { treesitter = { "lsp" } },
                },
            },

            signature = { enabled = true, window = { border = "rounded" } },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            snippets = { preset = "default" }, -- native vim.snippet
            fuzzy    = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
}
