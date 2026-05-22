-- nvim-lint: dispatches CLI linters and surfaces results as diagnostics.
-- Currently wired for lua (luacheck). bashls already handles shellcheck for shell,
-- and lua_ls handles syntax/semantic lua diagnostics — luacheck adds stylistic checks.
return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "InsertLeave" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				lua = { "luacheck" },
			}

			-- Tell luacheck to respect .luacheckrc files found upward from the file.
			-- The nvim config has one at ~/.config/nvim/.luacheckrc that declares vim globals.
			lint.linters.luacheck.args = {
				"--formatter",
				"plain",
				"--codes",
				"--ranges",
				"--filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
				"-",
			}

			local group = vim.api.nvim_create_augroup("UserLint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = group,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
