-- lua/plugins/jdtls.lua
return {
    {
        "mfussenegger/nvim-jdtls",
        -- Disable jdtls formatting (google-java-format instead)
        opts = function(_, opts)
            opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
                java = {
                    format = {
                        enabled = false,
                    },
                },
            })
            return opts
        end,
    },
}
