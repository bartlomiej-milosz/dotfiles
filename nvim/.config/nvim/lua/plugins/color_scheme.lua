return {
	-- auto-dark-mode.nvim setup
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.cmd("colorscheme kanso-ink")
				vim.api.nvim_set_option("background", "dark")
				-- vim.g.tokyobones_darkness = "warm" -- Adjust lightness flavour
				-- vim.g.tokyobones_lighten_comments = 25
			end,
			set_light_mode = function()
				vim.cmd("colorscheme kanso-pearl")
				vim.api.nvim_set_option("background", "light")
				-- vim.g.tokyobones_lightness = "dim"
				-- vim.g.tokyobones_darken_comments = 25
			end,
		},
	},

	-- zenbones-theme setup
	-- {
	--   "zenbones-theme/zenbones.nvim",
	--   dependencies = "rktjmp/lush.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   config = function()
	--     vim.opt.termguicolors = true
	--     vim.g.tokyobones_italic_comments = true
	--   end,
	-- },

	-- kenso-theme setup
	{
		"webhooked/kanso.nvim",
		lazy = false,
		priority = 1000,
	},
}
