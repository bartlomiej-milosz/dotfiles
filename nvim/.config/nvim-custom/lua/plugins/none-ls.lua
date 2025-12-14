return {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason-org/mason.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                -- Formatters
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.google_java_format,
                null_ls.builtins.formatting.prettier.with({
                    filetypes = { "json", "yaml", "markdown", "xml" },
                }),
                -- Linters
                null_ls.builtins.diagnostics.markdownlint,
            },

            -- Format on save
            on_attach = function(client, bufnr)
                if client:supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                timeout_ms = 3000,
                            })
                        end,
                    })
                end
            end,
        })

        -- Keymaps
        vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format file" })
    end,
}
