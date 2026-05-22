-- nvim-dap: Debug Adapter Protocol. UI + virtual text + language adapters for Python & Go.
-- Bash and Lua have no adapter configured by design (per project notes).
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
			{ "theHamsta/nvim-dap-virtual-text", opts = { commented = true } },
			{ "mfussenegger/nvim-dap-python" },
			{ "leoluz/nvim-dap-go" },
		},
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Condition: "))
				end,
				desc = "Conditional breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step out",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run last",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle UI",
			},
			{
				"<leader>dK",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Inspect (hover)",
			},
			-- Python-specific test runners (nvim-dap-python)
			{
				"<leader>dpt",
				function()
					require("dap-python").test_method()
				end,
				desc = "Python: debug nearest test",
				ft = "python",
			},
			{
				"<leader>dpc",
				function()
					require("dap-python").test_class()
				end,
				desc = "Python: debug test class",
				ft = "python",
			},
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			-- ── Signs ────────────────────────────────────────────────────
			local sign = vim.fn.sign_define
			sign("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
			sign("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
			sign("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
			sign("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })
			sign("DapBreakpointRejected", { text = "○", texthl = "DiagnosticError", linehl = "", numhl = "" })

			-- ── UI ───────────────────────────────────────────────────────
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.30 },
							{ id = "breakpoints", size = 0.15 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.30 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
				floating = { border = "rounded" },
			})

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- ── Python (debugpy via uv-managed env, falls back to Mason install) ─
			local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(vim.fn.executable(mason_debugpy) == 1 and mason_debugpy or "python3")

			-- ── Go (delve) ───────────────────────────────────────────────
			require("dap-go").setup()
		end,
	},
}
