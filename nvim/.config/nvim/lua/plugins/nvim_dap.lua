return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
    },
    config = function()
        local dap = require("dap")
        local dap_python = require("dap-python")
        local dapui = require("dapui")

        -- Dynamic Python path (works with virtualenvs)
        local mason_debugpy = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
        dap_python.setup(mason_debugpy)

        -- Setup the dap UI with default configuration
        dapui.setup({})

        -- Auto open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
        end

        -- Keybindings for DAP
        vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "[D]ebug [S]tart" })
        vim.keymap.set("n", "<leader>dc", dapui.close, { desc = "[D]ebug [C]lose" })
        vim.keymap.set("n", "<F1>", dap.step_over, { desc = "[D]ebug Step Over" })
        vim.keymap.set("n", "<F2>", dap.step_into, { desc = "[D]ebug Step Into" })
        vim.keymap.set("n", "<F3>", dap.step_out, { desc = "[D]ebug Step Out" })
        vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "[D]ebug Toggle [B]reakpoint" })

        -- Custom breakpoint icon
        vim.fn.sign_define("DapBreakpoint", { text = "🐶", texthl = "Error", linehl = "", numhl = "" })
    end,
}
