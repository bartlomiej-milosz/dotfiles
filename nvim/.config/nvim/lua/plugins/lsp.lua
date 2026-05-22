-- LSP: nvim-lspconfig drives server start/attach; mason installs the binaries.
-- Linting comes from the LSPs themselves (ruff for Python, bashls/shellcheck, gopls).
return {
    -- ── Mason: package manager for LSPs/formatters/debuggers/linters ─────
    {
        "williamboman/mason.nvim",
        cmd  = { "Mason", "MasonInstall", "MasonUpdate" },
        opts = {
            ui = { border = "rounded", icons = { package_installed = "●", package_pending = "◐", package_uninstalled = "○" } },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        event        = "VeryLazy",
        opts         = {
            run_on_start  = true,
            start_delay   = 2000,
            ensure_installed = {
                -- Formatters (driven by conform.nvim)
                "stylua", "shfmt", "gofumpt", "goimports", "golines",
                -- Linters (shellcheck is picked up by bashls automatically when on PATH)
                "shellcheck",
                -- Debug adapters
                "debugpy", "delve",
                -- LSPs not auto-installed via mason-lspconfig
            },
        },
    },

    -- ── LSP servers ──────────────────────────────────────────────────────
    {
        "neovim/nvim-lspconfig",
        event        = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        config       = function()
            -- Diagnostics presentation
            vim.diagnostic.config({
                virtual_text   = { spacing = 2, prefix = "●" },
                severity_sort  = true,
                update_in_insert = false,
                float          = { border = "rounded", source = true },
                signs          = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN]  = "",
                        [vim.diagnostic.severity.INFO]  = "",
                        [vim.diagnostic.severity.HINT]  = "",
                    },
                },
            })

            -- Borders for hover/signature
            local orig_open = vim.lsp.util.open_floating_preview
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
                opts = opts or {}; opts.border = opts.border or "rounded"
                return orig_open(contents, syntax, opts, ...)
            end

            -- Capabilities (blink-aware so completion advertises full LSP support)
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- ── Per-server settings ──────────────────────────────────────
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace      = { checkThirdParty = false },
                            telemetry      = { enable = false },
                            diagnostics    = { globals = { "vim", "Snacks", "MiniIcons", "MiniPick", "MiniTrailspace" } },
                            completion     = { callSnippet = "Replace" },
                            hint           = { enable = true },
                        },
                    },
                },
                basedpyright = {
                    settings = {
                        basedpyright = {
                            analysis = {
                                typeCheckingMode    = "standard",
                                autoImportCompletions = true,
                                diagnosticMode      = "openFilesOnly",
                                useLibraryCodeForTypes = true,
                                inlayHints = {
                                    variableTypes = true,
                                    callArgumentNames = true,
                                    functionReturnTypes = true,
                                },
                            },
                        },
                    },
                },
                ruff = {
                    -- Ruff handles lint diagnostics + organize imports.
                    -- Formatting goes through conform (also calls ruff), so disable hover here
                    -- to avoid clashing with basedpyright.
                    on_attach = function(client, _)
                        client.server_capabilities.hoverProvider = false
                    end,
                },
                bashls = {
                    filetypes = { "sh", "bash" },
                    settings  = {
                        bashIde = {
                            globPattern = "*@(.sh|.inc|.bash|.command)",
                        },
                    },
                },
                gopls = {
                    settings = {
                        gopls = {
                            gofumpt           = true,
                            completeUnimported = true,
                            usePlaceholders   = true,
                            staticcheck       = true,
                            hints = {
                                assignVariableTypes      = true,
                                compositeLiteralFields   = true,
                                compositeLiteralTypes    = true,
                                constantValues           = true,
                                functionTypeParameters   = true,
                                parameterNames           = true,
                                rangeVariableTypes       = true,
                            },
                            analyses = {
                                unusedparams = true,
                                shadow       = true,
                            },
                        },
                    },
                },
            }

            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
                automatic_enable = false, -- we wire each server explicitly below
            })

            for name, opts in pairs(servers) do
                opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
                vim.lsp.config(name, opts)
                vim.lsp.enable(name)
            end

            -- ── Per-buffer LSP keymaps ───────────────────────────────────
            vim.api.nvim_create_autocmd("LspAttach", {
                group    = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
                callback = function(args)
                    local buf = args.buf
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
                    end

                    -- Navigation (uses mini.pick for list views)
                    map("n", "gd",         "<cmd>Pick lsp scope='definition'<cr>",      "Goto definition")
                    map("n", "gD",         vim.lsp.buf.declaration,                      "Goto declaration")
                    map("n", "gr",         "<cmd>Pick lsp scope='references'<cr>",      "References")
                    map("n", "gI",         "<cmd>Pick lsp scope='implementation'<cr>",  "Implementation")
                    map("n", "gy",         "<cmd>Pick lsp scope='type_definition'<cr>", "Type definition")
                    map("n", "K",          vim.lsp.buf.hover,                            "Hover")
                    map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help,               "Signature help")

                    -- Refactor / actions
                    map("n", "<leader>cr", vim.lsp.buf.rename,        "Rename symbol")
                    map("n", "<leader>ca", vim.lsp.buf.code_action,   "Code action")
                    map("v", "<leader>ca", vim.lsp.buf.code_action,   "Code action")
                    map("n", "<leader>cs", "<cmd>Pick lsp scope='document_symbol'<cr>",   "Document symbols")
                    map("n", "<leader>cS", "<cmd>Pick lsp scope='workspace_symbol'<cr>",  "Workspace symbols")

                    -- Diagnostics
                    map("n", "<leader>xd", vim.diagnostic.open_float, "Line diagnostics")
                    map("n", "[d",         function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
                    map("n", "]d",         function() vim.diagnostic.jump({ count = 1 })  end, "Next diagnostic")

                    -- Inlay hints toggle (if supported)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
                        map("n", "<leader>uh",
                            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf }) end,
                            "Toggle inlay hints")
                    end
                end,
            })
        end,
    },
}
