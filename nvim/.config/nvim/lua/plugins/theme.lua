return {
	-- ── Xcode: Apple's native, clean light + dark palettes ──
	{
		"lunacookies/vim-colors-xcode",
		lazy = false,
		priority = 1000,
	},

	-- ── Auto dark/light mode based on macOS system preference ──
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 999,
		opts = {
			update_interval = 1000,

			set_dark_mode = function()
				vim.o.background = "dark"
				vim.cmd.colorscheme("xcodedark")
			end,

			set_light_mode = function()
				vim.o.background = "light"
				vim.cmd.colorscheme("xcodelight")
			end,
		},
	},
}
