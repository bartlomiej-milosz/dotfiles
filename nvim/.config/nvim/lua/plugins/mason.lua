return {
	-- Mason plugin to manage external dependencies like LSP, DAP, etc.
	{
		"williamboman/mason.nvim",
		config = function()
			-- Setup mason with default properties
			require("mason").setup({
				-- Optional configurations can be added here if needed
			})
		end,
	},
	-- Mason lspconfig plugin to automatically manage LSP servers
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			-- Ensure LSP servers are installed automatically
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "ruff" }, -- Add more servers if needed
			})
		end,
	},
}
