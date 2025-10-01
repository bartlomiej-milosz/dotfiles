return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "saghen/blink.cmp", -- For completion capabilities
    },
    config = function()
        -- ========================================
        -- UI Configuration
        -- ========================================
        vim.diagnostic.config({
            virtual_text = {
                spacing = 4,
                prefix = "●",
                severity = {
                    min = vim.diagnostic.severity.HINT,
                },
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = "󰠠 ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
            },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        -- ========================================
        -- LSP Handlers (Hover & Signature Help)
        -- ========================================
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
            max_width = 80,
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "rounded",
            max_width = 80,
        })

        -- ========================================
        -- LSP Attach Autocommand (Keymaps & Options)
        -- ========================================
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                local bufnr = ev.buf

                -- Enable completion triggered by <c-x><c-o>
                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

                -- Buffer-local options
                local opts = { buffer = bufnr, silent = true }

                -- ========================================
                -- Navigation Keymaps
                -- ========================================
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
                vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to References" }))
                vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to Type Definition" }))
                vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
                vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))

                -- ========================================
                -- Code Actions & Refactoring
                -- ========================================
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))

                -- ========================================
                -- Diagnostics
                -- ========================================
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
                vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show Diagnostic" }))
                vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, vim.tbl_extend("force", opts, { desc = "Diagnostics to Quickfix" }))
                vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostics to Loclist" }))

                -- ========================================
                -- Workspace
                -- ========================================
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add Workspace Folder" }))
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove Workspace Folder" }))
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, vim.tbl_extend("force", opts, { desc = "List Workspace Folders" }))

                -- ========================================
                -- Formatting
                -- ========================================
                if client and client:supports_method("textDocument/formatting") then
                    vim.keymap.set("n", "<leader>cf", function()
                        vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
                    end, vim.tbl_extend("force", opts, { desc = "Format File" }))
                end

                -- ========================================
                -- Inlay Hints (Neovim 0.10+)
                -- ========================================
                if client and client:supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                    vim.keymap.set("n", "<leader>ch", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
                    end, vim.tbl_extend("force", opts, { desc = "Toggle Inlay Hints" }))
                end

                -- ========================================
                -- Document Highlighting (on CursorHold)
                -- ========================================
                if client and client:supports_method("textDocument/documentHighlight") then
                    local highlight_augroup = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = bufnr,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = bufnr,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        -- ========================================
        -- Global LSP Configuration (vim.lsp.config)
        -- Modern Neovim 0.11+ API
        -- ========================================

        -- Default capabilities for all servers (blink.cmp integration)
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- Configure all servers with default settings
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        -- ========================================
        -- Server-Specific Configurations
        -- ========================================

        -- Lua Language Server (lua_ls)
        vim.lsp.config.lua_ls = {
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                            "${3rd}/luv/library",
                        },
                    },
                    telemetry = {
                        enable = false,
                    },
                    format = {
                        enable = false, -- Use stylua instead
                    },
                    hint = {
                        enable = true,
                    },
                },
            },
        }

        -- JSON Language Server (jsonls)
        vim.lsp.config.jsonls = {
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        }

        -- YAML Language Server (yamlls)
        vim.lsp.config.yamlls = {
            settings = {
                yaml = {
                    schemaStore = {
                        enable = false,
                        url = "",
                    },
                    schemas = require("schemastore").yaml.schemas(),
                    format = {
                        enable = true,
                    },
                    validate = true,
                },
            },
        }

        -- XML Language Server (lemminx)
        vim.lsp.config.lemminx = {
            settings = {
                xml = {
                    server = {
                        workDir = "~/.cache/lemminx",
                    },
                },
            },
        }

        -- ========================================
        -- Mason-LSPConfig Integration
        -- Automatically enables LSP servers installed via Mason
        -- ========================================
    end,
}
