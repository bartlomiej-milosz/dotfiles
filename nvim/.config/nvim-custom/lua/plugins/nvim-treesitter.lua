return {
    -- Core treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "java",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "json",
                    "yaml",
                    "xml",
                    "regex",
                    "bash",
                },

                sync_install = false,
                auto_install = true,

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },

    -- nvim-treesitter-textobjects is required for mini.ai treesitter integration
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- Optionaly move it into plugins/nvim-mini.lua
    -- Or keep it here since it is treesitter specififc config
    {
        'nvim-mini/mini.ai',
        event = "VeryLazy",
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-treesitter/nvim-treesitter-textobjects'
        },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500, -- Search within 500 lines for text objects

                custom_textobjects = {
                    -- Treesitter-based objects
                    f = ai.gen_spec.treesitter({
                        a = "@function.outer",
                        i = "@function.inner"
                    }),
                    c = ai.gen_spec.treesitter({
                        a = "@class.outer",
                        i = "@class.inner"
                    }),
                    o = ai.gen_spec.treesitter({ -- code blocks
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),

                    -- Pattern-based objects
                    d = { "%f[%d]%d+" },                                       -- digits
                    u = ai.gen_spec.function_call(),                           -- function call/usage
                    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dots
                },
            }
        end,
    }
}
