return {
    -- Mason: Package manager
    {
        "mason-org/mason.nvim",
        opts = {
            -- Optional configurations can be added here if needed
        },
        keys = {
            { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
        },
    },

    -- Mason-LSPConfig: Auto-install LSP servers
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "lua_ls",  -- Lua
                "jsonls",  -- JSON
                "yamlls",  -- YAML
                "lemminx", -- XML
                "jdtls",   -- Java
            },
            automatic_installation = true,
        },
    },

    -- Mason-Tool-Installer: Auto-install formatters and linters
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                -- Formatters (using correct Mason package names)
                "stylua",   -- Lua
                "prettier", -- JSON/YAML/XML/Markdown

                -- Java
                "java-debug-adapter", -- For debugging
                "java-test",          -- For running tests

                -- Linters
                "markdownlint", -- Markdown
            },
            auto_update = false,
            run_on_start = true,
        },
    },
}
