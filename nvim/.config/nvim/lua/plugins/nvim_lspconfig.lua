return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lsp_config = require("plugins_config.lsp")

        lsp_config.lua_config(lspconfig, capabilities)
        lsp_config.python_config(lspconfig, capabilities)
        lsp_config.ruff_config(lspconfig, capabilities)

        vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
        vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition" })
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "[C]ode Goto [R]eferences" })
        vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, { desc = "[C]ode Goto [I]mplementations" })
        vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
        vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration" })
    end,
}
