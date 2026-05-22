-- conform.nvim: file-format dispatch. Format on save with a fallback to LSP formatting.
return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd   = { "ConformInfo" },
        keys  = {
            { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, mode = { "n", "v" }, desc = "Format buffer / selection" },
            { "<leader>uf", function() vim.g.disable_autoformat = not vim.g.disable_autoformat end, desc = "Toggle format-on-save" },
        },
        opts  = {
            notify_on_error = true,
            format_on_save  = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                return { timeout_ms = 1500, lsp_format = "fallback" }
            end,
            formatters_by_ft = {
                lua    = { "stylua" },
                python = { "ruff_organize_imports", "ruff_format" },
                sh     = { "shfmt" },
                bash   = { "shfmt" },
                go     = { "goimports", "gofumpt" },
                json   = { "prettierd", "prettier", stop_after_first = true },
                yaml   = { "prettierd", "prettier", stop_after_first = true },
                markdown = { "prettierd", "prettier", stop_after_first = true },
            },
            formatters = {
                shfmt = { prepend_args = { "-i", "2", "-ci", "-bn" } },
            },
        },
    },
}
